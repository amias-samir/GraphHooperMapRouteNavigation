import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/model/instructions.dart';

class AudioInstructionController extends ChangeNotifier {
  // text audio ko instace yaha banayera enable audio disable garauney yaha bata

  /// List of [Instruction] identifier which is already spoken
  ///
  final List<String> _hadSpokenInstructionsIdentifier = [];

  /// Getter for [_hadSpokenInstructionsIdentifier]
  ///
  List<String> get hadSpokenInstructionsIdentifier =>
      _hadSpokenInstructionsIdentifier;

  /// [TextToSpeech] instance
  ///
  final FlutterTts tts = FlutterTts();

  /// Enable audio instance variable
  ///
  bool enableAudio = true;

  /// Call this method to recite the instruction
  /// Remember: This method internally checks [enableAudio]
  /// if false then it will not work.
  ///
  void speakInstruction({
    required Instruction instruction,
  }) async {
    if (!_checkIfInstructionIsAlreadySpoken(instruction: instruction)) {
      // if the instruction is not spoken then add it to the list
      _addSpokenInstructionsToList(instruction: instruction);

      //check if the audio is enabled
      if (enableAudio) {
        await tts.speak('en-US');
        if (instruction.text == null && kDebugMode) {
          await tts.speak('No Text found');
        } else {
          await tts.speak(instruction.text!);
        }
      }
    }
  }

  /// Add spoken instruction to the list of [hadSpokenInstructionsIdentifier]
  ///
  void _addSpokenInstructionsToList({
    required Instruction instruction,
  }) {
    _hadSpokenInstructionsIdentifier
        .add('${instruction.distance}_${instruction.sign}_${instruction.time}');
  }

  /// Method which sets the value for [enableAudio] variable
  ///
  void setEnableAudio({bool enableAudio = true}) {
    this.enableAudio = enableAudio;
    notifyListeners();
  }

  /// This method check if any [Instruction] is already spoken
  /// That means it is already present in [hadSpokenInstructionsIdentifier]
  ///
  bool _checkIfInstructionIsAlreadySpoken({
    required Instruction instruction,
  }) {
    return hadSpokenInstructionsIdentifier.contains(
        '${instruction.distance}_${instruction.sign}_${instruction.time}');
  }
}
