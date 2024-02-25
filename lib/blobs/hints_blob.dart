import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';

class WarningHintsBlob extends StatelessWidget {
  final String title;
  final String hint;

  const WarningHintsBlob(this.title, this.hint, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await launchInformDialog(context,
          message: const Text.rich(TextSpan(children: <InlineSpan>[
            TextSpan(
                text: "This is a Warning Hint\n\n",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "Hints they are meant to help you utilize the app better. They come in these flavors:\n 1. Informational - You can identify them by their blue bodies\n 2. Warning - You can identify them by their orange yellowish bodies indicating you should be mindful\n 3. Apex - You can identify them by their red bodies indicating that you should tread carefully"),
            TextSpan(
                text:
                    "\n\nIf you don't want to see them, you can turn them off in the settings.",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ])),
          title: "What are these? (exoad's memo)"),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.amber[400]),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: <Widget>[
                const Icon(Icons.warning_amber_rounded,
                    size: 24, color: Colors.black),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black)),
                        const SizedBox(height: 4),
                        Text(
                          hint,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black),
                          softWrap: true,
                        )
                      ]),
                ),
              ]),
            )),
      ),
    );
  }
}

class ApexHintsBlob extends StatelessWidget {
  final String title;
  final String hint;

  const ApexHintsBlob(this.title, this.hint, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await launchInformDialog(context,
          message: const Text.rich(TextSpan(children: <InlineSpan>[
            TextSpan(
                text: "This is an Apex Hint\n\n",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "Hints are meant to help you utilize the app better. They come in these flavors:\n 1. Informational - You can identify them by their blue bodies\n 2. Warning - You can identify them by their orange yellowish bodies indicating you should be mindful\n 3. Apex - You can identify them by their red bodies indicating that you should tread carefully"),
            TextSpan(
                text:
                    "\n\nIf you don't want to see them, you can turn them off in the settings.",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ])),
          title: "What are these? (exoad's memo)"),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 235, 23, 20)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: <Widget>[
                const Icon(CommunityMaterialIcons.skull_outline,
                    size: 26, color: Colors.white),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(
                          hint,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white),
                          softWrap: true,
                        )
                      ]),
                ),
              ]),
            )),
      ),
    );
  }
}

class InformationalHintsBlob extends StatelessWidget {
  final String title;
  final String hint;

  const InformationalHintsBlob(this.title, this.hint, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await launchInformDialog(context,
          message: const Text.rich(TextSpan(children: <InlineSpan>[
            TextSpan(
                text: "This is an Informational Hint\n\n",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "Hints are meant to help you utilize the app better. They come in these flavors:\n 1. Informational - You can identify them by their blue bodies\n 2. Warning - You can identify them by their orange yellowish bodies indicating you should be mindful\n 3. Apex - You can identify them by their red bodies indicating that you should tread carefully"),
            TextSpan(
                text:
                    "\n\nIf you don't want to see them, you can turn them off in the settings.",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ])),
          title: "What are these? (exoad's memo)"),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue[400]),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: <Widget>[
                const Icon(Icons.info_outline_rounded,
                    size: 24, color: Colors.black),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black)),
                        const SizedBox(height: 4),
                        Text(
                          hint,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black),
                          softWrap: true,
                        )
                      ]),
                ),
              ]),
            )),
      ),
    );
  }
}
