import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class AboutAppView extends StatelessWidget implements AppPageViewExporter {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text.rich(TextSpan(
            //text: "asdawfsuiunnnnnnnnnnnnnnnnnnnn\n",
            children: <TextSpan>[
          TextSpan(
              text: "2638 Scout\n",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 21,
                decoration:TextDecoration.underline,
              ),
          ),
          TextSpan(
            text: "Version 0.0.??\n01/19/2023",
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
              text: "App Development Team (Flutter/Dart)\n",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                decoration:TextDecoration.underline,
              )),
          TextSpan(
            text: "Jack Meng\nAiden Pan\nChiming Wang",
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
                decoration:TextDecoration.underline,
              )),
          TextSpan(
            text: "Flutter/Dart\nVisual Studio Code\nGithub",
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
                decoration:TextDecoration.underline,
              )),
          TextSpan(
            text: "John Motchkavitz\nMatthew Corrigan\nAndrea Zinn\nGeroge Motchkavitz\n",
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
        ])));
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
