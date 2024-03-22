import 'package:audio_player/controls.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

// 'https://firebasestorage.googleapis.com/v0/b/transcritor-ae356.appspot.com/o/audioFiles%2F13c7efff-458e-4b80-81e7-f2f12d8c6e1f-Rua-17-3.wav?alt=media&token=9b685376-66b6-498c-9e99-dfaa7f69a81e'

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer _player;

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream, (position, bufferedPosition, duration) {
      return PositionData(
        position,
        bufferedPosition,
        duration ?? Duration.zero,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()
      ..setUrl(
        'https://firebasestorage.googleapis.com/v0/b/transcritor-ae356.appspot.com/o/audioFiles%2F13c7efff-458e-4b80-81e7-f2f12d8c6e1f-Rua-17-3.wav?alt=media&token=9b685376-66b6-498c-9e99-dfaa7f69a81e',
      );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        title: const Text('Audio Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PositionData?>(
              stream: _positionDataStream,
              builder: (ctx, snap) {
                final positionData = snap.data;
                return ProgressBar(
                  barHeight: 8,
                  progress: positionData?.position ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  onSeek: _player.seek,
                );
              },
            ),
            Controls(player: _player),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}
