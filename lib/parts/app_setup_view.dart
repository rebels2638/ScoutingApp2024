import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/special_button.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/shared.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

import 'avatar_representator.dart';

bool _userNameChecker(String r) {
  return r.isNotEmpty &&
      r.contains(RegExp(
          r"^(?=[a-zA-Z0-9._]{4,20}$)(?!.*[_.]{2})[^_.].*[^_.]$"));
}

class AppSetupView extends StatefulWidget {
  final Widget routineChild;

  const AppSetupView({super.key, required this.routineChild});

  @override
  State<AppSetupView> createState() {
    return _AppSetupViewState();
  }
}

class _AppSetupViewState extends State<AppSetupView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opaTween;

  late bool isTappedDown;
  late bool isTappedOver;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    Debug().watchdog("App Setup View Launched (First State Step)");
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
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
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
                    physics: const NeverScrollableScrollPhysics(),
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
                                  child: SpecialButton.premade1(
                                    label: "Get Started",
                                    icon: const Icon(
                                        Icons.navigate_next_rounded),
                                    onPressed: () =>
                                        Future<void>.delayed(
                                            const Duration(
                                                milliseconds: 400),
                                            () {
                                      _pageController.animateToPage(1,
                                          duration: const Duration(
                                              milliseconds: 750),
                                          curve: Curves.ease);
                                      _controller
                                          .stop(); // no memory leaks ewww
                                    }),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      _UserProfileSetup(_pageController),
                      _FinalHelpfulTipsPage(() =>
                          Future<void>.delayed(
                              const Duration(milliseconds: 400), () {
                            UserTelemetry()
                                .currentModel
                                .profileArmed = true;
                            UserTelemetry().currentModel.profileId =
                                Shared.uuid.v4();
                            UserTelemetry().save();
                            Debug().info("User viewed the setup");
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                                MaterialPageRoute<Widget>(
                                    builder: (BuildContext context) =>
                                        widget.routineChild));
                          }))
                    ]),
              );
            }),
          ) // paranoia cuz FUCK BRO, WHAT HAPPENS IF IT GOES PAST THE SCREEN SIZE
            )
        : widget.routineChild;
  }
}

class _FinalHelpfulTipsPage extends StatelessWidget {
  final void Function() onTapped;

  const _FinalHelpfulTipsPage(this.onTapped);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 14),
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
              const SizedBox(height: 60),
              const Text.rich(
                TextSpan(
                    text: "Usage guide\n",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    children: <InlineSpan>[
                      TextSpan(
                          text:
                              "We are always here to help and listen to feedback, find methods of communication below.",
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal))
                    ]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SpecialButton.premade2(
                  shrinkWrap: false,
                  label: "Our GitHub Repository",
                  icon: const Icon(CommunityMaterialIcons.github),
                  onPressed: () async => await launchURLLaunchDialog(
                      context,
                      url: REBEL_ROBOTICS_APP_GITHUB_REPO_URL,
                      message:
                          "You are about to leave the app to visit our GitHub repository. Do you want to continue?")),
              const SizedBox(height: 30),
              SpecialButton.premade3(
                label: "Our Website Guide",
                icon: const Icon(CommunityMaterialIcons.web),
                shrinkWrap: false,
                onPressed: () async => await launchURLLaunchDialog(
                    context,
                    url: ARGUSGUIDE_URL,
                    message: // https://rebels2638.github.io/ArgusGuide/home
                        "You are about to leave the app to visit our Website Guide. Do you want to continue?"),
              ),
              const SizedBox(height: 30),
              SpecialButton.premade4(
                  label: "Our Tutorial Video",
                  icon: const Icon(CommunityMaterialIcons.youtube),
                  shrinkWrap: false,
                  onPressed: () async => await launchURLLaunchDialog(
                      context,
                      url: REBEL_ROBOTICS_APP_TUTORIAL_VIDEO_URL,
                      message:
                          "You are about to leave the app to visit our Tutorial Video. Do you want to continue?")),
              const SizedBox(height: 30),
              SpecialButton.premade5(
                  shrinkWrap: false,
                  label: "Our Team Website",
                  icon: const Icon(CommunityMaterialIcons.web),
                  onPressed: () async => await launchURLLaunchDialog(
                      context,
                      url: RebelRoboticsShared.website,
                      message:
                          "You are about to leave the app to visit our team website. Do you want to continue?")),
              const SizedBox(height: 60),
              SpecialButton.premade6(
                label: "Go to the app",
                icon: const Icon(Icons.navigate_next_rounded),
                onPressed: () => onTapped.call(),
              ),
              const SizedBox(height: 6),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.touch_app_rounded),
                    SizedBox(width: 6),
                    Text("Tap to finish setup")
                  ])
            ])));
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
  late bool isFuckedUsername;

  @override
  void initState() {
    super.initState();
    isFuckedUsername = false;
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
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(builder: (BuildContext context) {
                  return const AvatarRepresentator();
                })
              ]),
        ),
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
              errorText: isFuckedUsername
                  ? "The supplied name does not meet the requirements!"
                  : null,
              labelText: "Your Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8))),
        ),
        const Text(
            "This is the name that will be used to identify you in the app and to your scouting leader(s).",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic)),
        const SizedBox(height: 6),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text.rich(
            TextSpan(children: <InlineSpan>[
              TextSpan(
                  text: "Name requirements:\n",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "• 8-20 characters long\n"),
              TextSpan(text: "• No special characters\n"),
              TextSpan(text: "• Only a-z A-Z 0-9\n"),
              TextSpan(text: "• No spaces\n")
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: SpecialButton.premade1(
            label: "Submit",
            icon: const Icon(Icons.check_rounded),
            onPressed: () {
              if (_userNameChecker(_controller.text)) {
                Future<void>.delayed(
                    const Duration(milliseconds: 400), () {
                  FocusScopeNode currentFocus =
                      FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (_controller.text.isNotEmpty) {
                    Debug().info("SET NAME TO ${_controller.text}");
                    UserTelemetry().currentModel.profileName =
                        _controller.text;
                    widget._controllerInstance.animateToPage(2,
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.ease);
                  }
                });
              } else {
                setState(() => isFuckedUsername = true);
              }
            },
          ),
        )
      ]),
    ));
  }
}
