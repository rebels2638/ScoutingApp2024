import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSetupView extends StatefulWidget {
  final Widget routineChild;

  const AppSetupView({super.key, required this.routineChild});

  @override
  State<AppSetupView> createState() => _AppSetupViewState();
}

class _AppSetupViewState extends State<AppSetupView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Tween<double> _opaTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opaTween = Tween<double>(begin: 0, end: 1);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
          child: Column(children: <Widget>[
        AnimatedOpacity(
          opacity: _opaTween.evaluate(_controller),
          duration: const Duration(milliseconds: 1),
          child: Image.asset(
            "assets/appicon_header.png",
            width: 148,
            height: 148,
          ),
        )
      ])),
    ) // paranoia cuz FUCK BRO, WHAT HAPPENS IF IT GOES PAST THE SCREEN SIZE
        );
  }
}
