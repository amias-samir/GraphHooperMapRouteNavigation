import 'package:flutter/widgets.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/audio_instruction_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/model/instructions.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/model/instructions_coords_and_index_list.dart';

/// [NavigationInstructionController] holds all the logic for showing the navigation instruction
/// on the screen.
///
class NavigationInstructionController extends ChangeNotifier {
  NavigationInstructionController({
    required DirectionRouteResponse directionRouteResponse,
    required this.audioInstructionController,
  }) {
    computeInstructionsCoordsAndIndex(directionRouteResponse);
  }

  /// [AudioInstructionController] instance
  ///
  final AudioInstructionController audioInstructionController;

  /// Private [Instruction] instance variable
  ///
  Instruction _instruction = Instruction();

  /// Getter for [_instruction]
  ///
  Instruction get instruction => _instruction;

  /// [InstructionsCoordsAndIndexList] instance
  ///
  InstructionsCoordsAndIndexList? instructionsCoordsAndIndexList;

  /// Updates [_instruction]
  ///
  void updateInstructions(Instruction instruction) {
    _instruction = instruction;
    notifyListeners();
  }

  /// compute instructions cordinates and index
  ///
  void computeInstructionsCoordsAndIndex(
      DirectionRouteResponse directionRouteResponse) {
    final instructions =
        directionRouteResponse.paths![0].instructions?.reversed.toList() ?? [];

    final indexList = <int>[];
    final instructionsCoordList = <List<double>>[];

    for (final instruction in instructions) {
      final index = instruction.interval![0];
      indexList.add(index);
      instructionsCoordList
          .add(directionRouteResponse.paths![0].points!.coordinates![index]);
    }

    instructionsCoordsAndIndexList =
        InstructionsCoordsAndIndexList(instructionsCoordList, indexList);
  }

  void checkIsCoordinateInsideCircle({
    required DirectionRouteResponse directionRouteResponse,
    required LatLng usersLatLng,
  }) async {
    InstructionsCoordsIndexListAndUsersLoc
        instructionsCoordsIndexListAndUsersLoc =
        InstructionsCoordsIndexListAndUsersLoc(
            instructionsCoordsAndIndexList!.instructionsCoordsList,
            instructionsCoordsAndIndexList!.instructionsIndexList,
            directionRouteResponse,
            usersLatLng);

    Instruction instruction =
        computingCoordinateInsideCircle(instructionsCoordsIndexListAndUsersLoc);
    // await compute(computingCoordinateInsideCircle,
    //     instructionsCoordsIndexListAndUsersLoc);
    debugPrint(
        'RouteNavigationRouteController outCompute ${instruction.toJson()}');

    if (instruction.text != null && instruction.text!.isNotEmpty) {
      // update the intruction with response
      updateInstructions(instruction);
    }

    // AudioInstruction audioInstruction = AudioInstruction(tts: tts.value, instructions: instructions, enableAudio: enabledAudio.value,
    //     instructionsList: hadSpokenInstructions, instructionsIdentifier: hadSpokenInstructionsIdentifier );
    //
    // await compute(computeAndPlayInstructionAudio, audioInstruction);

    audioInstructionController.speakInstruction(instruction: instruction);
  }

  Instruction computingCoordinateInsideCircle(
      InstructionsCoordsIndexListAndUsersLoc
          instructionsCoordsIndexListAndUsersLoc) {
    DirectionRouteResponse directionRouteResponse1 =
        instructionsCoordsIndexListAndUsersLoc.directionRouteResponse;
    Instruction instruction = Instruction(text: '');
    List<List<double>> instructionPoints =
        instructionsCoordsIndexListAndUsersLoc.instructionsCoordsList;

    if (instructionPoints.isNotEmpty) {
      for (int index = 0; index < instructionPoints.length; index++) {
        if (CalculatorUtils.isCoordinateInside(
            instructionLatLng: LatLng(
                instructionPoints[index][1], instructionPoints[index][0]),
            usersLatLng: instructionsCoordsIndexListAndUsersLoc.usersLatLng)) {
          // TODO: make he direction route response a single variable
          instruction = directionRouteResponse1.paths![0].instructions!.reversed
              .toList()[index];
          debugPrint(
              'RouteNavigationRouteController compute : ${directionRouteResponse1.paths![0].instructions![index].toJson()}');
        }
        // else{
        //    instruction = directionRouteResponse1.paths![0].instructions![index];
        // }
      }
    }
    return instruction;
  }
}
