import 'package:flutter_tts/flutter_tts.dart';

import 'instructions.dart';

class AudioInstruction {
  FlutterTts? _tts;
  List<Instruction>? _instructionsList;
  List<String>? _instructionsIdentifier;
  Instruction? _instructions;
  bool? _enableAudio;

  FlutterTts get tts => _tts!;

  set tts(FlutterTts value) {
    _tts = value;
  }

  bool get enableAudio => _enableAudio!;

  set enableAudio(bool value) {
    _enableAudio = value;
  }

  Instruction get instructions => _instructions!;

  set instructions(Instruction value) {
    _instructions = value;
  }

  List<Instruction> get instructionsList => _instructionsList!;

  set instructionsList(List<Instruction> value) {
    _instructionsList = value;
  }

  List<String> get instructionsIdentifier => _instructionsIdentifier!;

  set instructionsIdentifier(List<String> value) {
    _instructionsIdentifier = value;
  }

  AudioInstruction({
    required FlutterTts tts,
    List<Instruction>? instructionsList,
    List<String>? instructionsIdentifier,
    required Instruction instructions,
    required bool enableAudio,
  }) {
    _tts = tts;
    _instructionsList = instructionsList;
    _instructionsIdentifier = instructionsIdentifier;
    _instructions = instructions;
    _enableAudio = enableAudio;
  }
}
