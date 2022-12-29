
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'dart:math' as Math;
import 'dart:math' show Point, asin, atan2, cos, pi, sqrt ;

import '../model/audio_instruction.dart';
import '../model/direction_route_response.dart';
import '../model/instructions.dart';
import '../model/instructions_coords_and_index_list.dart';
import '../utils/calculator_utils.dart';



class RouteNavigationRouteController extends GetxController{

  // update user location  while simulating route
  Rx<UserLocation> userLocation = UserLocation(position:  const LatLng(28.987280, 80.1652), altitude: 1200.0,
      bearing: 0.0, speed: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0, timestamp: DateTime.now(),
      heading: UserHeading(magneticHeading: 0.0, trueHeading: 0.0, headingAccuracy: 0.0, x: 0.0, y: 0.0, z: 0.0,
          timestamp: DateTime.now()) ).obs;


  bool simulateNavigation = false;

  //degrees between two coordinates
  RxDouble bearingBtnCOOrds = 0.0.obs;

  //distance between two coordinates in list
  RxList<double> distanceBtnCOOrds = (List<double>.of([0.0])).obs;

  //user's speed
  RxDouble userSpeed = 0.0.obs;

  //remaining distance from user's location to the nearest instruction point
  double remaingDistanceToTheInstructionPoint = 0.0;

  //nearest current instruction (identified based on user's location)
  Rx<Instructions> instruction =  Instructions(text: '').obs;

  //list of instructions that had spoken once
  RxList<Instructions> hadSpokenInstructions =  (List<Instructions>.of([])).obs;
  
  //list of instructions identifier that had spoken once (generate unique by using instructions multiple value)
  RxList<String> hadSpokenInstructionsIdentifier =  (List<String>.of([])).obs;

  //direction route response
  Rx<DirectionRouteResponse> directionRouteResponse = DirectionRouteResponse().obs;

  //list of instruction's index value (instructions found in direction route response)
  RxList<int> instructionsIndexList = (List<int>.of([])).obs;

  //list of instruction's Coordinate value (instructions found in direction route response)
  RxList<List<double>> instructionsCoordList = (List<List<double>>.of([])).obs;

  // RxDouble distanceToTheInstPoint = 0.0.obs;

  //enable/disable test to speech
  RxBool enabledAudio = true.obs;

  //initialize Text To Speech
  Rx<TextToSpeech> tts = TextToSpeech().obs ;


  //Degrees between two coordinates
  calculateBearingBtwn2Coords(LatLng startLatLng, LatLng endLatLng) async {

    double lat1 = startLatLng.latitude;
    double lat2 = endLatLng.latitude;
    double lng1 = startLatLng.longitude;
    double lng2 = endLatLng.longitude;

    double dLon = (lng2-lng1);
    double y = Math.sin(dLon) * Math.cos(lat2);
    double x = Math.cos(lat1)*Math.sin(lat2) - Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
    double radian = (Math.atan2(y, x));
    double bearing = math.degrees(radian);

    bearing = (360 - ((bearing + 360) % 360));
    debugPrint('RouteNavigationRouteController bearing :  $bearing');
    updateBearing(bearing: bearing);
  }

  double calculateDistance(LatLng startLatLng, LatLng endLatLng){
    // distance in Meters
    // if you want distance in Kilo Meters, Just divide by 1000
    double lat1 = startLatLng.latitude;
    double lat2 = endLatLng.latitude;
    double lng1 = startLatLng.longitude;
    double lng2 = endLatLng.longitude;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lng2 - lng1) * p))/2;
    double distance =  12742 * asin(sqrt(a)) *1000;

    updateDistanceBtnCOOrds(distance: distance);
    return distance;
  }

  double calculateSpeed (double distance, int time){
    double microToSecond = time / 1000000;
    double speed = distance / microToSecond;
    updateSpeed(speed: speed);
    debugPrint('RouteNavigationRouteController speed :  $speed');
    return speed;
  }

  updateBearing({required double bearing}){
    bearingBtnCOOrds.value = double.parse(bearing.toStringAsFixed(3));
  }

  updateDistanceBtnCOOrds({required double distance}){

    distanceBtnCOOrds.refresh();
    distanceBtnCOOrds.value.first = double.parse(distance.toStringAsFixed(2));
    distanceBtnCOOrds.refresh();
    remaingDistanceToTheInstructionPoint = distance;
    // update();

    debugPrint('RouteNavigationRouteController calculateDistance :  ${distanceBtnCOOrds.value}');

  }

  // updateDistance(double distance){
  //   distanceToTheInstPoint.value  = double.parse(distance.toStringAsFixed(2));
  // }


  updateSpeed({required double speed}){
    userSpeed.value = double.parse(speed.toStringAsFixed(3));
  }

  updateUserLocation({required UserLocation userLocation}){
    this.userLocation.value = userLocation;
  }


  simulateRouting(List<List<double>> points, UserLocation userLocation,
      {bool simulateRoute = true}) async {

    DateTime dateTimePrev = DateTime.now();

    int count = 0;
     Timer.periodic(const Duration(seconds: 2), (timer) {

       if(!simulateRoute){
         count = 0;
         timer.cancel();
       }

      if(count < points.length){
        if(count < points.length-1){
          UserLocation userLocation1 = UserLocation(position:  LatLng(points[count][1], points[count][0]), altitude: userLocation.altitude,
              bearing: userLocation.bearing, speed: userLocation.speed, horizontalAccuracy: userLocation.horizontalAccuracy,
              verticalAccuracy: userLocation.verticalAccuracy, timestamp: userLocation.timestamp,
              heading: UserHeading(magneticHeading: 0.0, trueHeading: 0.0,
                  headingAccuracy: 0.0, x: 0.0, y: 0.0,
                  z: 0.0, timestamp: userLocation.timestamp) );
          updateUserLocation(userLocation: userLocation1);


          calculateBearingBtwn2Coords(LatLng(points[count][1], points[count][0]), LatLng(points[count+1][1], points[count+1][0]));

          Duration diff = DateTime.now().difference(dateTimePrev);
          dateTimePrev = DateTime.now();
              calculateSpeed(calculateDistance(LatLng(points[count][1], points[count][0]), LatLng(points[count+1][1], points[count+1][0])),
              diff.inMicroseconds);

          checkIsCoordinateInsideCircle(usersLatLng: userLocation1.position);
        }
      }else if(count == points.length){
        UserLocation userLocation1 = UserLocation(position:  LatLng(points[count][1], points[count][0]), altitude: userLocation.altitude,
            bearing: userLocation.bearing, speed: userLocation.speed, horizontalAccuracy: userLocation.horizontalAccuracy,
            verticalAccuracy: userLocation.verticalAccuracy, timestamp: userLocation.timestamp,
            heading: UserHeading(magneticHeading: 0.0, trueHeading: 0.0,
                headingAccuracy: 0.0, x: 0.0, y: 0.0,
                z: 0.0, timestamp: userLocation.timestamp) );
        updateUserLocation(userLocation: userLocation1);

        checkIsCoordinateInsideCircle(usersLatLng: userLocation1.position);



        timer.cancel();
      }


      count = count+1;
      });
  }


  findInstructionsCoordsAndIndex({required DirectionRouteResponse directionRouteResponse }) async{
    this.directionRouteResponse.value = directionRouteResponse;

    InstructionsCoordsAndIndexList instructionsCoordsAndIndexList = await compute(computingInstructionsCoordsAndIndex, directionRouteResponse);
    instructionsIndexList.value = instructionsCoordsAndIndexList.instructionsIndexList;
    instructionsCoordList.value = instructionsCoordsAndIndexList.instructionsCoordsList;

    // debugPrint('findInstructionsCoordsAndIndex  indexList : ${instructionsCoordsAndIndexList.instructionsIndexList}');
    // debugPrint('findInstructionsCoordsAndIndex  coordsList : ${instructionsCoordsAndIndexList.instructionsCoordsList}');

  }

  Future<InstructionsCoordsAndIndexList> computingInstructionsCoordsAndIndex(DirectionRouteResponse directionRouteResponse)async {

    List<Instructions> instructions = directionRouteResponse.paths![0].instructions!;

    List<int> indexList = [];
    List<List<double>> instructionsCoordList = [];
    InstructionsCoordsAndIndexList instructionsCoordsAndIndexList = InstructionsCoordsAndIndexList(instructionsCoordList, indexList);

    if(instructions.isNotEmpty){
      for(int index = 0 ; index < instructions.length ; index++){
        Instructions instruction = instructions[index];

        indexList.add(instruction.interval![0]);
        instructionsCoordList.add(directionRouteResponse.paths![0].points!.coordinates![instruction.interval![0]]);
      }
    }

    instructionsCoordsAndIndexList =  InstructionsCoordsAndIndexList(instructionsCoordList, indexList);

    return instructionsCoordsAndIndexList;
  }

  getInstructionByIndex({required DirectionRouteResponse directionRouteResponse, required int index}){
    instruction.value = directionRouteResponse.paths![0].instructions![index];
  }


  checkIsCoordinateInsideCircle({required LatLng usersLatLng}) async {

    List<double> coordinates = [];
    coordinates.add(usersLatLng.latitude);
    coordinates.add(usersLatLng.longitude);

    InstructionsCoordsIndexListAndUsersLoc instructionsCoordsIndexListAndUsersLoc = InstructionsCoordsIndexListAndUsersLoc(instructionsCoordList.value, instructionsIndexList.value, directionRouteResponse.value, usersLatLng);

    Instructions instructions = await compute(computingCoordinateInsideCircle, instructionsCoordsIndexListAndUsersLoc);
    debugPrint('RouteNavigationRouteController outCompute ${instructions.toJson()}');

    instruction.refresh();
    instruction.value = instructions;
    instruction.refresh();


    // AudioInstruction audioInstruction = AudioInstruction(tts: tts.value, instructions: instructions, enableAudio: enabledAudio.value,
    //     instructionsList: hadSpokenInstructions, instructionsIdentifier: hadSpokenInstructionsIdentifier );
    //
    // await compute(computeAndPlayInstructionAudio, audioInstruction);


  }

  setEnableAudio({required bool enableAudio, required TextToSpeech textToSpeech}){
    enabledAudio.value = enableAudio;
    tts.value = textToSpeech;
  }

addHadSpokenInstructionsToList({required Instructions instructions}) {
    hadSpokenInstructions.add(instructions);
    hadSpokenInstructionsIdentifier.add('${instructions.distance}_${instructions.sign}_${instructions.time}');

    debugPrint('RouteNavigationRouteController addHadSpokenInstructionsToList : ${hadSpokenInstructionsIdentifier.toString()}');

}


}


Future<Instructions> computingCoordinateInsideCircle(InstructionsCoordsIndexListAndUsersLoc instructionsCoordsIndexListAndUsersLoc)async {

  final controller = RouteNavigationRouteController();
  DirectionRouteResponse directionRouteResponse1 = instructionsCoordsIndexListAndUsersLoc.directionRouteResponse;
  Instructions instruction = Instructions(text: '');
  List<List<double>> instructionPoints = instructionsCoordsIndexListAndUsersLoc.instructionsCoordsList;



  if(instructionPoints.isNotEmpty){
    for(int index = 0 ; index < instructionPoints.length ; index++){


      if(calculatorUtils.isCoordinateInside(
          instructionLatLng: LatLng(instructionPoints[index][1], instructionPoints[index][0]),
          usersLatLng: instructionsCoordsIndexListAndUsersLoc.usersLatLng)){
        instruction = directionRouteResponse1.paths![0].instructions![index];
        debugPrint('RouteNavigationRouteController compute : ${directionRouteResponse1.paths![0].instructions![index].toJson()}');

        controller.calculateDistance(instructionsCoordsIndexListAndUsersLoc.usersLatLng, LatLng(instructionPoints[index][1], instructionPoints[index][0]));
      }
      // else{
      //    instruction = directionRouteResponse1.paths![0].instructions![index];
      // }

    }
  }

  return instruction;
}


computeAndPlayInstructionAudio(AudioInstruction audioInstruction) async{
  switch(audioInstruction.enableAudio){
    case true:
      RouteNavigationRouteController routeNavigationRouteController = RouteNavigationRouteController();
      // TextToSpeech tts =TextToSpeech();
      if(!audioInstruction.instructionsIdentifier.contains('${audioInstruction.instructions.distance}_${audioInstruction.instructions.sign}_${audioInstruction.instructions.time}')){
        routeNavigationRouteController.addHadSpokenInstructionsToList(instructions: audioInstruction.instructions);

        debugPrint('RouteNavigationRouteController addHadSpoken computeAndPlayInstructionAudio : ${audioInstruction.instructionsIdentifier.toString()}');
        // await audioInstruction.tts.setLanguage('en-US');
        // await audioInstruction.tts.speak(audioInstruction.instructions.text! );
      }
      break;

    case false :
      // await audioInstruction.tts.stop();
      break;
  }

}
