import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/obfs_blob.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/shared.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const String _DIVIDER = "\n\n";

class AboutAppView extends StatefulWidget
    implements AppPageViewExporter {
  const AboutAppView({super.key});

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.info_rounded),
        icon: const Icon(Icons.info_outline_rounded),
        label: "About",
        tooltip: "About 2638 Scouting Application"
      )
    );
  }

  @override
  State<AboutAppView> createState() => _AboutAppViewState();
}

class _AboutAppViewState extends State<AboutAppView> {
  late final ScrollController _scroller;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _scroller = ScrollController();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _scroller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Transform.translate(
        offset: Offset(
            0, _scroller.hasClients ? -_scroller.offset / 3 : 0),
        child: ObfsBlob(
          sigmaX: 6,
          sigmaY: 6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, bottom: 20, left: 20, right: 20),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  RepaintBoundary(
                    child: Image.asset(
                      "assets/2324_teampic.jpg",
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ColoredBox(color: Colors.black.withOpacity(0.4)),
                ],
              ),
            ),
          ),
        ),
      ),
      NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notif) {
            setState(() {});
            return false;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            controller: _scroller,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: GestureDetector(
                              onTap: () {
                                setState(
                                    () => _confettiController.play());
                                Debug().info("Confetti_EE: Played");
                              },
                              child: Stack(children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ConfettiWidget(
                                    blastDirection: 0,
                                    minBlastForce:
                                        7, // OMG IS THAT AN ODD NUMBER IN THE UI??? WTFFFFF!!!!?!?!?!?!1111!?!?!
                                    shouldLoop: false,
                                    confettiController:
                                        _confettiController,
                                    colors: const <Color>[
                                      RebelRoboticsShared.REBELS_BLUE,
                                      RebelRoboticsShared
                                          .REBELS_ORANGE
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ConfettiWidget(
                                    blastDirection: pi,
                                    shouldLoop: false,
                                    minBlastForce: 7,
                                    confettiController:
                                        _confettiController,
                                    colors: const <Color>[
                                      RebelRoboticsShared.REBELS_BLUE,
                                      RebelRoboticsShared
                                          .REBELS_ORANGE
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                      "assets/2324_teampic.jpg",
                                      width: 530,
                                      height: 430),
                                ),
                              ]))),
                    ),
                    const SizedBox(height: 18),
                    ...contentBase(context)
                  ]),
            ),
          )),
    ]);
  }

  List<Widget> contentBase(BuildContext context) {
    return strutAll(
      <Widget>[
        Center(
          // lets gooo its const
          child: Text.rich(
              const TextSpan(
                  //text: "asdawfsuiunnnnnnnnnnnnnnnnnnnn\n",
                  children: <TextSpan>[
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                            text: "26",
                            style: TextStyle(
                                color:
                                    RebelRoboticsShared.REBELS_BLUE)),
                        TextSpan(
                            text: "38",
                            style: TextStyle(
                                color: RebelRoboticsShared
                                    .REBELS_ORANGE)),
                        TextSpan(text: " Scouting App\n")
                      ],
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                        //decoration:TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: "Version $REBEL_ROBOTICS_APP_VERSION",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: _DIVIDER,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                        text: "Lead\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          //decoration:TextDecoration.underline,
                        )),
                    TextSpan(
                      text: "Jack Meng",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: _DIVIDER,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                        text: "Team\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          //decoration:TextDecoration.underline,
                        )),
                    TextSpan(
                      text:
                          "Chiming Wang\nRichard Xu\nAarav Minocha\nAiden Pan",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: _DIVIDER,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                        text: "Helpers\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          //decoration:TextDecoration.underline,
                        )),
                    TextSpan(
                      text: "Conner Shea",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: _DIVIDER,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                        text: "Tools Used\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          //decoration:TextDecoration.underline,
                        )),
                    TextSpan(
                      text:
                          "Flutter/Dart\nVisual Studio Code\nGithub",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: _DIVIDER,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                        text: "Special thanks to\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          //decoration:TextDecoration.underline,
                        )),
                    TextSpan(
                      text:
                          "John Motchkavitz\nMatthew Corrigan\nAndrea Zinn\nGeroge Motchkavitz\n",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "And all of our amazing mentors!",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]),
              style: TextStyle(color: Colors.white, shadows: <Shadow>[
                Shadow(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .shadowColor,
                    blurRadius: 2,
                    offset: const Offset(1, 1))
              ]),
              textAlign: TextAlign.center,
              softWrap: true),
        ),
        IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: strutAll(<Widget>[
              preferTonalButton(
                  onPressed: () async => await launchConfirmDialog(
                      context,
                      message: const Text(
                          "You are about to visit this app's source code on Github."),
                      onConfirm: () async => await launchUrl(
                          Uri.parse(
                              REBEL_ROBOTICS_APP_GITHUB_REPO_URL))),
                  label: const Text("Source Code"),
                  icon: const Icon(Icons.data_object_rounded)),
              preferTonalButton(
                  onPressed: () => showLicensePage(
                      context: context,
                      applicationIcon: const Image(
                          image: ExactAssetImage(
                              "assets/appicon_header.png")),
                      applicationLegalese:
                          REBEL_ROBOTICS_APP_LEGALESE,
                      applicationVersion:
                          REBEL_ROBOTICS_APP_VERSION.toString(),
                      applicationName: REBEL_ROBOTICS_APP_NAME),
                  label: const Text("Open Source licenses"),
                  icon: const Icon(Icons.library_books_rounded)),
              preferTonalButton(
                  onPressed: () async => await launchConfirmDialog(
                      context,
                      title: "Font \"IBM Plex\"",
                      showOkLabel: false,
                      icon: const Icon(Icons.library_books_rounded),
                      denyLabel: "Ok",
                      message: FutureBuilder<String>(
                          future: DefaultAssetBundle.of(context)
                              .loadString("assets/legals/OFL.txt"),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> byteData) {
                            if (byteData.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (byteData.hasError ||
                                !byteData.hasData) {
                              return const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.warning_rounded),
                                    SizedBox(width: 10),
                                    Text(
                                        "There was an error retrieving...")
                                  ]);
                            }
                            return SingleChildScrollView(
                                child: Text(byteData.data!));
                          }),
                      onConfirm: () => Debug()
                          .info("Popped FONT_LICENSE View Screen")),
                  label: const Text("Font license"),
                  icon: const Icon(Icons.font_download_rounded)),
              preferTonalButton(
                  onPressed: () async => await launchConfirmDialog(
                      context,
                      title: "BSD-4 License",
                      showOkLabel: false,
                      icon: const Icon(Icons.library_books_rounded),
                      denyLabel: "Ok",
                      message: FutureBuilder<String>(
                          future: DefaultAssetBundle.of(context)
                              .loadString("assets/legals/BSD-4.txt"),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> byteData) {
                            if (byteData.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (byteData.hasError ||
                                !byteData.hasData) {
                              return const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.warning_rounded),
                                    SizedBox(width: 10),
                                    Text(
                                        "There was an error retrieving...")
                                  ]);
                            }
                            return SingleChildScrollView(
                                child: Text(byteData.data!));
                          }),
                      onConfirm: () => Debug().info(
                          "Popped SOFTWARE_LICENSE View Screen")),
                  label: const Text("Software license"),
                  icon: const Icon(Icons.library_books_rounded)),
              const SizedBox(height: 30),
            ], height: 16),
          ),
        )
      ],
      height: 26,
    );
  }
}
