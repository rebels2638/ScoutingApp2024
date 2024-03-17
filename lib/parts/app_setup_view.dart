import 'package:flutter/material.dart';
import 'package:scouting_app_2024/extern/alignment.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:scouting_app_2024/user/gradient_descriptor.dart';
import 'package:scouting_app_2024/utils.dart';

class AppSetupView extends StatefulWidget {
  final Widget routineChild;

  const AppSetupView({super.key, required this.routineChild});

  @override
  State<AppSetupView> createState() => _AppSetupViewState();
}

class _AppSetupViewState extends State<AppSetupView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opaTween;

  late final AnimationController _shadowController;
  late final Animation<Offset> _shadowTween;

  late bool isTappedDown;
  late bool isTappedOver;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    isTappedDown = false;
    isTappedOver = false;
    _pageController =
        PageController(keepPage: false /*bc we dont go back*/);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _opaTween = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn))
      ..addListener(() => setState(() {}));
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _shadowTween = Tween<Offset>(
            begin: const Offset(-4, -4), end: const Offset(4, 4))
        .animate(CurvedAnimation(
            parent: _shadowController, curve: Curves.easeInOut))
      ..addListener(() => setState(() {}));
    _shadowController.repeat(reverse: true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isTappedOver
        ? Scaffold(
            body: Opacity(
            opacity: _opaTween.value,
            child: Builder(builder: (BuildContext context) {
              return SafeArea(
                child: PageView(
                    controller: _pageController,
                    allowImplicitScrolling: false,
                    children: <Widget>[
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Column(children: <Widget>[
                                Hero(
                                  tag: "appicon-getstarted",
                                  child: Image.asset(
                                    "assets/appicon_header.png",
                                    width: 148,
                                    height: 148,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text("Welcome to Argus",
                                    style: TextStyle(
                                        fontSize: 52,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Damion")),
                                const SizedBox(height: 6),
                                const Text(
                                    "Built for the 2024 FRC Season by Team 2638",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                              ]),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top:
                                        120), // this is so fucking scuffed for strutting
                                child: GestureDetector(
                                  onTapDown: (_) => setState(() =>
                                      isTappedDown =
                                          true), // for asethetics shit, idk how to spell the word :P
                                  onTap: () => Future<void>.delayed(
                                      const Duration(
                                          milliseconds: 400),
                                      () => WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (_) {
                                            _pageController.animateToPage(
                                                1,
                                                duration:
                                                    const Duration(
                                                        milliseconds:
                                                            750),
                                                curve: Curves.ease);
                                            _shadowController.stop();
                                            _controller
                                                .stop(); // no memory leaks ewww
                                          })),
                                  child: FittedBox(
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 400),
                                      decoration: BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: !isTappedDown
                                                    ? const Color
                                                        .fromARGB(132,
                                                        65, 170, 107)
                                                    : const Color
                                                        .fromARGB(190,
                                                        240, 53, 29),
                                                offset: _shadowTween
                                                    .value,
                                                blurRadius: 10)
                                          ],
                                          gradient: !isTappedDown
                                              ? const LinearGradient(
                                                  begin: Alignment
                                                      .topLeft,
                                                  end:
                                                      Alignment.bottomRight,
                                                  colors: <Color>[
                                                      Color.fromARGB(
                                                          255,
                                                          55,
                                                          125,
                                                          66),
                                                      Color.fromARGB(
                                                          255,
                                                          22,
                                                          102,
                                                          83)
                                                    ])
                                              : const LinearGradient(
                                                  begin:
                                                      Alignment
                                                          .topRight,
                                                  end: Alignment
                                                      .bottomLeft,
                                                  colors: <Color>[
                                                      Color.fromARGB(
                                                          255,
                                                          216,
                                                          148,
                                                          53),
                                                      Color.fromARGB(
                                                          255,
                                                          209,
                                                          24,
                                                          24)
                                                    ]),
                                          borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(
                                                      8))),
                                      padding:
                                          const EdgeInsets.all(16),
                                      child: const Row(
                                        children: <Widget>[
                                          Icon(Icons
                                              .navigate_next_rounded),
                                          Text("Get Started",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: Color(
                                                      0xFFFFFFFF))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _UserProfileSetup(_pageController)
                    ]),
              );
            }),
          ) // paranoia cuz FUCK BRO, WHAT HAPPENS IF IT GOES PAST THE SCREEN SIZE
            )
        : widget.routineChild;
  }
}

class _UserProfileSetup extends StatefulWidget {
  final PageController _controllerInstance;

  const _UserProfileSetup(this._controllerInstance);

  @override
  State<_UserProfileSetup> createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<_UserProfileSetup> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
      child: Column(children: <Widget>[
        const SizedBox(height: 10),
        Hero(
          tag: "appicon-getstarted",
          child: Image.asset(
            "assets/appicon_header.png",
            width: 76,
            height: 76,
          ),
        ),
        const Text("User Information",
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Builder(builder: (BuildContext context) {
                return const AvatarRepresentator();
              })
            ]),
        const SizedBox(height: 6),
        const Text(
            "Argus does not collect any telemetry about you. However, scouting data you collect and store in Argus can be shared with others.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                fontWeight: FontWeight.normal)),
        const SizedBox(height: 24),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
              labelText: "Your Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8))),
        ),
        const Text(
            "This is the name that will be used to identify you in the app and to your scouting leader(s).",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.normal)),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: FilledButton.tonalIcon(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text("Submit")),
        )
      ]),
    ));
  }
}

class AvatarRepresentator extends StatefulWidget {
  const AvatarRepresentator({
    super.key,
  });

  @override
  State<AvatarRepresentator> createState() =>
      _AvatarRepresentatorState();
}

class _AvatarRepresentatorState extends State<AvatarRepresentator> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {}),
      child: SizedBox(
        width: 124,
        height: 124,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                gradient: LinearGradientDescriptor.random().gr)),
      ),
    );
  }
}
