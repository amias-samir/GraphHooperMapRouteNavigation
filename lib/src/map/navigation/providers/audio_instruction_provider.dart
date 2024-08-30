import 'package:flutter/widgets.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/audio_instruction_controller.dart';
import 'package:flutter/material.dart';

/// [AudioInstructionController] instance this class will be passed down the widget tree.
///
final audioInstructionController = AudioInstructionController();

/// Provides an instance of [AudioInstructionController] to its descendants in the widget tree.
///
/// This is an [InheritedWidget] that allows widgets to access the [AudioInstructionController]
/// without needing to pass it down manually through constructors.
class AudioInstructionProvider extends InheritedWidget {
  /// The [AudioInstructionController] that this widget provides to its descendants.
  final AudioInstructionController audioInstructionController;

  /// Creates an [AudioInstructionProvider].
  ///
  /// The [audioInstructionController] and [child] parameters are required.
  const AudioInstructionProvider({
    super.key,
    required this.audioInstructionController,
    required super.child,
  });

  /// Retrieves the nearest [AudioInstructionProvider] up the widget tree and returns
  /// its [audioInstructionController].
  ///
  /// This method throws a [FlutterError] if no [AudioInstructionProvider] is found in the
  /// widget tree.
  static AudioInstructionController of(BuildContext context) {
    final AudioInstructionProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AudioInstructionProvider>();
    if (provider == null) {
      throw FlutterError(
          'AudioInstructionProvider.of() called with a context that does not contain an AudioInstructionProvider.');
    }
    return provider.audioInstructionController;
  }

  /// Determines whether the widget tree should be rebuilt when the [audioInstructionController] changes.
  ///
  /// Returns `true` if the new [audioInstructionController] is different from the old one, otherwise `false`.
  @override
  bool updateShouldNotify(covariant AudioInstructionProvider oldWidget) {
    return oldWidget.audioInstructionController != audioInstructionController;
  }
}
