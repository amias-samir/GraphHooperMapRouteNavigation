import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/navigation_instruction_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/map_controller_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/map_utils.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../model/direction_route_response.dart';
import '../model/instructions.dart';
import '../model/instructions_coords_and_index_list.dart';
import '../utils/calculator_utils.dart';

class RouteNavigationRouteController extends GetxController {
  // update user location  while simulating route
  Rx<UserLocation> userLocation = UserLocation(
          position: const LatLng(28.987280, 80.1652),
          altitude: 1200.0,
          bearing: 0.0,
          speed: 0.0,
          horizontalAccuracy: 0.0,
          verticalAccuracy: 0.0,
          timestamp: DateTime.now(),
          heading: UserHeading(
              magneticHeading: 0.0,
              trueHeading: 0.0,
              headingAccuracy: 0.0,
              x: 0.0,
              y: 0.0,
              z: 0.0,
              timestamp: DateTime.now()))
      .obs;

  bool simulateNavigation = false;

  //distance between two coordinates in list
  // RxList<double> distanceBtnCOOrds = (List<double>.of([0.0])).obs;

  //remaining distance from user's location to the nearest instruction point
  double remaingDistanceToTheInstructionPoint = 0.0;

  //list of instructions that had spoken once
  // RxList<Instruction> hadSpokenInstructions = (List<Instruction>.of([])).obs;

  //list of instructions identifier that had spoken once (generate unique by using instructions multiple value)
  // RxList<String> hadSpokenInstructionsIdentifier = (List<String>.of([])).obs;

  //direction route response
  // Rx<DirectionRouteResponse> directionRouteResponse =
  //     DirectionRouteResponse().obs;

  //list of instruction's index value (instructions found in direction route response)
  // RxList<int> instructionsIndexList = (List<int>.of([])).obs;

  //list of instruction's Coordinate value (instructions found in direction route response)
  // RxList<List<double>> instructionsCoordList = (List<List<double>>.of([])).obs;

  // RxDouble distanceToTheInstPoint = 0.0.obs;

  //enable/disable test to speech
  // RxBool enabledAudio = true.obs;

  //initialize Text To Speech
  // Rx<TextToSpeech> tts = TextToSpeech().obs ;
  // TextToSpeech tts = TextToSpeech();

  // double calculateDistance(LatLng startLatLng, LatLng endLatLng) {
  //   // distance in Meters
  //   // if you want distance in Kilo Meters, Just divide by 1000
  //   double lat1 = startLatLng.latitude;
  //   double lat2 = endLatLng.latitude;
  //   double lng1 = startLatLng.longitude;
  //   double lng2 = endLatLng.longitude;

  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 -
  //       c((lat2 - lat1) * p) / 2 +
  //       c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
  //   double distance = 12742 * asin(sqrt(a)) * 1000;

  //   // updateDistanceBtnCOOrds(distance: distance);
  //   return distance;
  // }

  double calculateSpeed(double distance, int time) {
    double microToSecond = time / 1000000;
    double speed = distance / microToSecond;
    // updateSpeed(speed: speed);
    debugPrint('RouteNavigationRouteController speed :  $speed');
    return speed;
  }

  // updateDistanceBtnCOOrds({required double distance}) {
  //   distanceBtnCOOrds.refresh();
  //   List<double> list = [double.parse(distance.toStringAsFixed(2))];
  //   distanceBtnCOOrds(list);
  //   distanceBtnCOOrds.refresh();
  //   remaingDistanceToTheInstructionPoint = distance;
  //   update();

  //   // debugPrint('RouteNavigationRouteController calculateDistance :  ${distanceBtnCOOrds.iterator.current}');
  // }

  // updateDistance(double distance){
  //   distanceToTheInstPoint.value  = double.parse(distance.toStringAsFixed(2));
  // }

  // void updateUserLocation({required UserLocation userLocation}) {
  //   this.userLocation.value = userLocation;
  // }

  void simulateRouting(
      DirectionRouteResponse? directionRouteResponse, UserLocation userLocation,
      {bool simulateRoute = true}) async {
    List<List<double>> points =
        directionRouteResponse!.paths![0].points!.coordinates!;

    // hadSpokenInstructionsIdentifier.value = [];

    DateTime dateTimePrev = DateTime.now();

    int count = 0;
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!simulateRoute) {
        count = 0;
        timer.cancel();
      }

      if (count < points.length) {
        if (count < points.length - 1) {
          UserLocation userLocation1 = UserLocation(
              position: LatLng(points[count][1], points[count][0]),
              altitude: userLocation.altitude,
              bearing: userLocation.bearing,
              speed: userLocation.speed,
              horizontalAccuracy: userLocation.horizontalAccuracy,
              verticalAccuracy: userLocation.verticalAccuracy,
              timestamp: userLocation.timestamp,
              heading: UserHeading(
                  magneticHeading: 0.0,
                  trueHeading: 0.0,
                  headingAccuracy: 0.0,
                  x: 0.0,
                  y: 0.0,
                  z: 0.0,
                  timestamp: userLocation.timestamp));

          // use map controller to animate camera with bearing value
          await mapScreenController
              .updateUserLocationCircleAndAnimate(userLocation1);

          // use map controller to update bearing
          mapScreenController.animateCameraWithBearingValue(
            bearingValue: MapUtils.calculateBearingBtnTwoCords(
                startLatLng: LatLng(points[count][1], points[count][0]),
                endLatLng: LatLng(points[count + 1][1], points[count + 1][0])),
          );

          Duration diff = DateTime.now().difference(dateTimePrev);
          dateTimePrev = DateTime.now();

          // calculateSpeed(
          //     calculateDistance(LatLng(points[count][1], points[count][0]),
          //         LatLng(points[count + 1][1], points[count + 1][0])),
          //     diff.inMicroseconds);

          checkIsCoordinateInsideCircle(usersLatLng: userLocation1.position);
        }
      } else if (count == points.length) {
        UserLocation userLocation1 = UserLocation(
            position: LatLng(points[count - 1][1], points[count - 1][0]),
            altitude: userLocation.altitude,
            bearing: userLocation.bearing,
            speed: userLocation.speed,
            horizontalAccuracy: userLocation.horizontalAccuracy,
            verticalAccuracy: userLocation.verticalAccuracy,
            timestamp: userLocation.timestamp,
            heading: UserHeading(
                magneticHeading: 0.0,
                trueHeading: 0.0,
                headingAccuracy: 0.0,
                x: 0.0,
                y: 0.0,
                z: 0.0,
                timestamp: userLocation.timestamp));

        // use map controller to animate camera with bearing value
        await mapScreenController
            .updateUserLocationCircleAndAnimate(userLocation1);

        checkIsCoordinateInsideCircle(usersLatLng: userLocation1.position);

        timer.cancel();
      }

      count = count + 1;
    });
  }

  /// This method finds instructions co-ordinates i.e latitude ra longitude
  // void findInstructionsCoordsAndIndex(
  //     {required DirectionRouteResponse directionRouteResponse}) async {
  // initializes controller's directionRoute response variable
  // this.directionRouteResponse.value = directionRouteResponse;

  // call func
  // setEnableAudio();

  // InstructionsCoordsAndIndexList instructionsCoordsAndIndexList =
  //      computeInstructionsCoordsAndIndex(directionRouteResponse);
  // await compute(
  //     computeInstructionsCoordsAndIndex, directionRouteResponse);
  // InstructionsCoordsAndIndexList instructionsCoordsAndIndexList =
  //     await compute(
  //         computeInstructionsCoordsAndIndex, directionRouteResponse);

  // update the rx variables in the controller
  // instructionsIndexList.value =
  //     instructionsCoordsAndIndexList.instructionsIndexList;
  // instructionsCoordList.value =
  //     instructionsCoordsAndIndexList.instructionsCoordsList;

  // debugPrint('findInstructionsCoordsAndIndex  indexList : ${instructionsCoordsAndIndexList.instructionsIndexList}');
  // debugPrint('findInstructionsCoordsAndIndex  coordsList : ${instructionsCoordsAndIndexList.instructionsCoordsList}');
  // }

  /// compute instructions cordinates and index
  ///
  // InstructionsCoordsAndIndexList computeInstructionsCoordsAndIndex(
  //     DirectionRouteResponse directionRouteResponse) {
  //   final instructions =
  //       directionRouteResponse.paths![0].instructions?.reversed.toList() ?? [];

  //   final indexList = <int>[];
  //   final instructionsCoordList = <List<double>>[];

  //   for (final instruction in instructions) {
  //     final index = instruction.interval![0];
  //     indexList.add(index);
  //     instructionsCoordList
  //         .add(directionRouteResponse.paths![0].points!.coordinates![index]);
  //   }

  //   return InstructionsCoordsAndIndexList(instructionsCoordList, indexList);
  // }

  // void getInstructionByIndex(
  //     {required DirectionRouteResponse directionRouteResponse,
  //     required int index}) {
  //   instruction.value = directionRouteResponse.paths![0].instructions![index];
  // }

  // void checkIsCoordinateInsideCircle({
  //   required LatLng usersLatLng,
  // }) async {
  //   InstructionsCoordsIndexListAndUsersLoc
  //       instructionsCoordsIndexListAndUsersLoc =
  //       InstructionsCoordsIndexListAndUsersLoc(
  //           instructionsCoordList.toList(),
  //           instructionsIndexList.toList(),
  //           directionRouteResponse.value,
  //           usersLatLng);

  //   Instruction instruction =
  //       computingCoordinateInsideCircle(instructionsCoordsIndexListAndUsersLoc);
  //   // await compute(computingCoordinateInsideCircle,
  //   //     instructionsCoordsIndexListAndUsersLoc);
  //   debugPrint(
  //       'RouteNavigationRouteController outCompute ${instruction.toJson()}');

  //   if (instruction.text != null && instruction.text!.isNotEmpty) {
  //     // update the intruction with response
  //     navigationInstructionProvider.updateInstructions(instruction);
  //   }

  //   // AudioInstruction audioInstruction = AudioInstruction(tts: tts.value, instructions: instructions, enableAudio: enabledAudio.value,
  //   //     instructionsList: hadSpokenInstructions, instructionsIdentifier: hadSpokenInstructionsIdentifier );
  //   //
  //   // await compute(computeAndPlayInstructionAudio, audioInstruction);

  //   //TODO: call speakInstruction() method here
  // }
}

// Instruction computingCoordinateInsideCircle(
//     InstructionsCoordsIndexListAndUsersLoc
//         instructionsCoordsIndexListAndUsersLoc) {
//   DirectionRouteResponse directionRouteResponse1 =
//       instructionsCoordsIndexListAndUsersLoc.directionRouteResponse;
//   Instruction instruction = Instruction(text: '');
//   List<List<double>> instructionPoints =
//       instructionsCoordsIndexListAndUsersLoc.instructionsCoordsList;

//   if (instructionPoints.isNotEmpty) {
//     for (int index = 0; index < instructionPoints.length; index++) {
//       if (CalculatorUtils.isCoordinateInside(
//           instructionLatLng:
//               LatLng(instructionPoints[index][1], instructionPoints[index][0]),
//           usersLatLng: instructionsCoordsIndexListAndUsersLoc.usersLatLng)) {
//         // TODO: make he direction route response a single variable
//         instruction = directionRouteResponse1.paths![0].instructions!.reversed
//             .toList()[index];
//         debugPrint(
//             'RouteNavigationRouteController compute : ${directionRouteResponse1.paths![0].instructions![index].toJson()}');
//       }
//       // else{
//       //    instruction = directionRouteResponse1.paths![0].instructions![index];
//       // }
//     }
//   }
//   return instruction;
// }

// computeAndPlayInstructionAudio(AudioInstruction audioInstruction) async {
//   switch (audioInstruction.enableAudio) {
//     case true:
//       RouteNavigationRouteController routeNavigationRouteController =
//           RouteNavigationRouteController();
//       // TextToSpeech tts =TextToSpeech();
//       if (!audioInstruction.instructionsIdentifier.contains(
//           '${audioInstruction.instructions.distance}_${audioInstruction.instructions.sign}_${audioInstruction.instructions.time}')) {
//         routeNavigationRouteController.addHadSpokenInstructionsToList(
//             instructions: audioInstruction.instructions);

//         debugPrint(
//             'RouteNavigationRouteController addHadSpoken computeAndPlayInstructionAudio : ${audioInstruction.instructionsIdentifier.toString()}');
//         // await audioInstruction.tts.setLanguage('en-US');
//         // await audioInstruction.tts.speak(audioInstruction.instructions.text! );
//       }
//       break;

//     case false:
//       // await audioInstruction.tts.stop();
//       break;
//   }
// }
