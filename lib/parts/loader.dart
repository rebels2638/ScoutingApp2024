import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/animate_blob.dart';
import 'package:scouting_app_2024/main.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:scouting_app_2024/debug.dart';

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
    Debug().warn(
        "Current Loaded Theme ${ThemeProvider.themeOf(context).id}");
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
                    return const IntermediateMaterialApp();
                  } else {
                    return const Scaffold(
                        body: Center(
                            child: SpinBlob(
                                child: Text("Loading :D",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight:
                                            FontWeight.w600)))));
                  }
                })));
  }
}
