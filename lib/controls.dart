import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.player});

  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (!(playing ?? false)) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 64.0,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 64.0,
            onPressed: player.pause,
          );
        } else {
          return const IconButton(
            icon: Icon(Icons.replay),
            iconSize: 64.0,
            onPressed: null,
          );
        }
      }
    );
  }
}
