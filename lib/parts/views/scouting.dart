import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:theme_provider/theme_provider.dart';

typedef SectionId = ({String title, IconData icon});

class ScoutingView extends StatelessWidget
    implements AppPageViewExporter {
  const ScoutingView({super.key});

  /// blob func
  static Widget _section(BuildContext context,
          {required SectionId header, required Widget child}) =>
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ThemeProvider.themeOf(context)
                  .data
                  .colorScheme
                  .onInverseSurface),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(header.icon, size: 26),
                    strut(width: 6),
                    Text(header.title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ]),
                  strut(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: child,
                  ),
                ],
              ),
            ),
          ));

  /// blob func
  static Widget _txtfield(
          {required String prompt,
          String? hint,
          Icon? prefixIcon,
          Icon? suffixIcon,
          void Function(String)? onSubmitted,
          void Function(String)? onChanged,
          TextInputType? inputType}) =>
      Row(children: <Widget>[
        Text(prompt),
        TextField(
          onChanged: (String e) => onChanged?.call(e),
          onSubmitted: (String e) => onSubmitted?.call(e),
          keyboardType: inputType,
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffix: suffixIcon,
              hintText: hint,
              border: const OutlineInputBorder()),
        )
      ]);

  @override
  Widget build(BuildContext context) {
    // MOCKUP, NOT FINAL
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: <Widget>[
          _section(context,
              header: (
                title: "Match",
                icon: Icons.accessibility_rounded
              ),
              child: Row())
        ]));
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.data_thresholding_rounded),
        icon: const Icon(Icons.data_thresholding_outlined),
        label: "Scouting",
        tooltip: "Data collection screen for observing matches"
      )
    );
  }
}
