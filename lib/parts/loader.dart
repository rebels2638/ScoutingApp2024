import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scouting_app_2024/blobs/animate_blob.dart';
import 'package:scouting_app_2024/main.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/debug.dart';

import 'themed_app_bundle.dart';

class LoadingAppViewScreen extends StatefulWidget {
  final Future<void> task;

  const LoadingAppViewScreen({
    super.key,
    required this.task,
  });

  @override
  State<LoadingAppViewScreen> createState() =>
      _LoadingAppViewScreenState();
}

class _LoadingAppViewScreenState extends State<LoadingAppViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 750),
            child: FutureBuilder<void>(
                future: widget.task,
                builder: (BuildContext context,
                    AsyncSnapshot<void> snapshot) {
                  Debug().info(
                      "LoadingAppViewScreen: ${snapshot.connectionState}");
                  if (snapshot.connectionState ==
                      ConnectionState.done) {
                    Debug().warn(
                        "Took ${DateTime.now().difference(APP_START_TIME).inMilliseconds}ms to load the app.");
                    return const ThemedAppBundle(
                        child: IntermediateMaterialApp());
                  } else {
                    return Scaffold(
                        body: SafeArea(
                          child: Container(
                                                decoration:
                            BoxDecoration(color: Colors.grey[900]),
                                                child: const Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpinBlob(
                                child: Image(
                              image: ExactAssetImage(
                                  "assets/appicon_header.png"),
                              width: 148,
                              height: 148,
                            )),
                            SizedBox(height: 30),
                            _UpdaterPhaseString()
                          ],
                                                )),
                                              ),
                        ));
                  }
                })));
  }
}

class _UpdaterPhaseString extends StatefulWidget {
  const _UpdaterPhaseString();

  @override
  State<_UpdaterPhaseString> createState() =>
      _UpdaterPhaseStringState();
}

class _UpdaterPhaseStringState extends State<_UpdaterPhaseString> {
  String _message = "Awaiting...";
  late StreamSubscription<LogRecord>
      _sub; // so we dont get memory leaks lol
  @override
  void initState() {
    super.initState();
    _sub = Debug().listen((LogRecord record) {
      if (!Debug.isPhase(record)) {
        setState(() => _message = record.message);
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _message,
      textAlign: TextAlign.center,
      softWrap: true,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          overflow: TextOverflow.ellipsis),
    );
  }
}
