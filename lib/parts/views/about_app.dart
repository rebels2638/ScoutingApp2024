import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppView extends StatelessWidget
    implements AppPageViewExporter {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: strutAll(
            <Widget>[
              const Center(
                  // lets gooo its const
                  child: Text.rich(TextSpan(
                      //text: "asdawfsuiunnnnnnnnnnnnnnnnnnnn\n",
                      children: <TextSpan>[
                    TextSpan(
                      text: "2638 Scouting App\n",
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
                      text: "\n\n\n\n",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                        text: "Development Team\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          //decoration:TextDecoration.underline,
                        )),
                    TextSpan(
                      text: "Jack Meng\nChiming Wang\nRichard Xu",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "\n\n\n",
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
                      text: "Aiden Pan\nAarav Minocha",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "\n\n\n",
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
                      text: "\n\n\n",
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
                  ]))),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () async => await launchConfirmDialog(
                            context,
                            message: const Text(
                                "You are about to visit this app's source code on Github."),
                            onConfirm: () async => await launchUrl(
                                Uri.parse(
                                    REBEL_ROBOTICS_APP_GITHUB_REPO_URL))),
                        label: const Text("Source Code"),
                        icon: const Icon(Icons.data_object_rounded)),
                    TextButton.icon(
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
                        icon:
                            const Icon(Icons.library_books_rounded)),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () async =>
                            await launchConfirmDialog(context,
                                title: "Font \"IBM Plex\"",
                                showOkLabel: false,
                                icon: const Icon(
                                    Icons.library_books_rounded),
                                denyLabel: "Ok",
                                message: FutureBuilder<String>(
                                    future: DefaultAssetBundle.of(
                                            context)
                                        .loadString(
                                            "assets/legals/OFL.txt"),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String>
                                            byteData) {
                                      if (byteData.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child:
                                                CircularProgressIndicator());
                                      }
                                      if (byteData.hasError ||
                                          !byteData.hasData) {
                                        return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                            children: <Widget>[
                                              const Icon(Icons
                                                  .warning_rounded),
                                              strut(width: 10),
                                              const Text(
                                                  "There was an error retrieving...")
                                            ]);
                                      }
                                      return SingleChildScrollView(
                                          child:
                                              Text(byteData.data!));
                                    }),
                                onConfirm: () => Debug().info(
                                    "Popped FONT_LICENSE View Screen")),
                        label: const Text("Font license"),
                        icon:
                            const Icon(Icons.font_download_rounded)),
                    TextButton.icon(
                        onPressed: () async => await launchConfirmDialog(
                            context,
                            title: "BSD-4 License",
                            showOkLabel: false,
                            icon: const Icon(
                                Icons.library_books_rounded),
                            denyLabel: "Ok",
                            message: FutureBuilder<String>(
                                future: DefaultAssetBundle.of(context)
                                    .loadString(
                                        "assets/legals/BSD-4.txt"),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> byteData) {
                                  if (byteData.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child:
                                            CircularProgressIndicator());
                                  }
                                  if (byteData.hasError ||
                                      !byteData.hasData) {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          const Icon(
                                              Icons.warning_rounded),
                                          strut(width: 10),
                                          const Text(
                                              "There was an error retrieving...")
                                        ]);
                                  }
                                  return SingleChildScrollView(
                                      child: Text(byteData.data!));
                                }),
                            onConfirm: () => Debug().info(
                                "Popped SOFTWARE_LICENSE View Screen")),
                        label: const Text("Software license"),
                        icon: const Icon(Icons.library_books_rounded))
                  ])
            ],
            height: 26,
          ),
        ),
      ),
    );
  }

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
}
