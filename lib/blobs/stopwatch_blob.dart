import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';

class StopwatchBlob extends StatefulWidget {
  const StopwatchBlob({super.key});

  @override
  State<StopwatchBlob> createState() => _StopwatchBlobState();
}

class _StopwatchBlobState extends State<StopwatchBlob> {
  late Duration _counter;
  late bool _pause;

  // BIG TODO
  @override
  void initState() {
    super.initState();
    _counter = Duration.zero;
    _pause = true;
  }

  void _startTimer() {
    _counter = Duration.zero;
    Timer.periodic(const Duration(seconds: 1), (Timer time) {
      _counter = Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      IconButton(
          onPressed: () /*TODO*/ {
            setState(() => _pause = !_pause);
          },
          icon: _pause
              ? const Icon(Icons.play_arrow_rounded)
              : const Icon(Icons.stop_rounded)),
      strut(width: 10),
      Text(_counter.inSeconds.toRadixString(16))
    ]);
  }
}
