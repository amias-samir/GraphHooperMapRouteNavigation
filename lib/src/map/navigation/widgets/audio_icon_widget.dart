import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/audio_instruction_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/widgets/my_location_zoom_icon_widget.dart';

class AudioIconWidget extends StatelessWidget {
  const AudioIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final audioInstructionController = AudioInstructionProvider.of(context);
    return ListenableBuilder(
        listenable: audioInstructionController,
        builder: (context, child) {
          final isAudioEnabled = audioInstructionController.enableAudio;

          return CustomFloatingActionButton(
              heroTag: 'tag_sound_enable_disable',
              onPressed: () {
                // toggle enable audio
                audioInstructionController.setEnableAudio(
                  enableAudio: !isAudioEnabled,
                );
              },
              iconData: isAudioEnabled ? Icons.volume_up : Icons.volume_off);
        });
  }
}
