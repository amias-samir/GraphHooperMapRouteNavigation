import 'package:text_to_speech/text_to_speech.dart';

import 'instructions.dart';

class AudioInstruction{
  TextToSpeech? _tts ;
  List<Instructions>? _instructionsList;
  List<String>? _instructionsIdentifier;
  Instructions? _instructions;
  bool? _enableAudio;

  TextToSpeech get tts => _tts!;

  set tts(TextToSpeech value) {
    _tts = value;
  }

  bool get enableAudio => _enableAudio!;

  set enableAudio(bool value) {
    _enableAudio = value;
  }

  Instructions get instructions => _instructions!;

  set instructions(Instructions value) {
    _instructions = value;
  }

  List<Instructions> get instructionsList => _instructionsList!;

  set instructionsList(List<Instructions> value) {
    _instructionsList = value;
  }

  List<String> get instructionsIdentifier => _instructionsIdentifier!;

  set instructionsIdentifier(List<String> value) {
    _instructionsIdentifier = value;
  }

  AudioInstruction({required TextToSpeech tts,  List<Instructions>? instructionsList, List<String>? instructionsIdentifier,
    required Instructions instructions, required bool enableAudio}){
    _tts = tts;
    _instructionsList = instructionsList ;
    _instructionsIdentifier = instructionsIdentifier ;
    _instructions = instructions ;
    _enableAudio = enableAudio;
  }
}
