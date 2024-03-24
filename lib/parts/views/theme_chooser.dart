import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/parts/theme_classifier.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeChooserView extends StatelessWidget {
  final List<AppTheme> appThemes;

  const ThemeChooserView({
    super.key,
  required this.appThemes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // i debugged this shit a fuck ton, it kept closing the scaffold. reaosn? it was using the original build(BuildContext) which was already gone lmao, fuck they should have nested shadowing rules
                    UserTelemetry().currentModel.selectedTheme =
                        ThemeClassifier.of(context).id;
                    UserTelemetry().save();
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text("Set",
                      style: TextStyle(fontWeight: FontWeight.bold)))
            ],
            centerTitle: true,
            title: const Row(children: <Widget>[
              Icon(Icons.palette_rounded),
              SizedBox(width: 10),
              Text("Theme Library")
            ])),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text.rich(
                  TextSpan(children: <InlineSpan>[
                    TextSpan(
                        text: AvailableTheme.of(
                                ThemeClassifier.of(context).id)
                            .properName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ", a Material ${ThemeProvider.themeOf(context).data.useMaterial3 ? "3" : "2"} theme")
                  ]),
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: appThemes.length,
                children: <Widget>[
                  for (AppTheme e in appThemes)
                    e.id != ThemeClassifier.of(context).id
                        ? ElevatedButton.icon(
                            style: ButtonStyle(
                                visualDensity:
                                    VisualDensity.comfortable,
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        e.data.primaryColor),
                                iconColor:
                                    MaterialStateProperty.all<Color>(
                                        e.data.iconTheme.color ??
                                            Colors.black),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        e.data.iconTheme.color ??
                                            Colors.black),
                                iconSize:
                                    MaterialStateProperty.all<double>(30),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(14))),
                            onPressed: () {
                              ThemeProvider.controllerOf(context)
                                  .setTheme(e.id);
                              UserTelemetry()
                                      .currentModel
                                      .selectedTheme =
                                  ThemeClassifier.of(context).id;
                              UserTelemetry().save();
                            },
                            icon: Column(
                              children: <Widget>[
                                Icon(AvailableTheme.of(
                                  e.id,
                                ).icon),
                                const SizedBox(height: 6),
                                if (e.data.brightness ==
                                    Brightness.dark)
                                  const Icon(Icons.nightlight_round,
                                      size: 14)
                                else
                                  const Icon(Icons.wb_sunny_rounded,
                                      size: 14)
                              ],
                            ),
                            label: Text.rich(TextSpan(children: <InlineSpan>[
                              TextSpan(
                                  text: AvailableTheme.of(e.id)
                                      .properName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const TextSpan(text: "\nBy "),
                              TextSpan(
                                  text:
                                      AvailableTheme.of(e.id).author,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic))
                            ])))
                        : OutlinedButton.icon(
                            style: ButtonStyle(visualDensity: VisualDensity.comfortable, iconColor: MaterialStateProperty.all<Color>(e.data.iconTheme.color ?? Colors.black), foregroundColor: MaterialStateProperty.all<Color>(e.data.iconTheme.color ?? Colors.black), iconSize: MaterialStateProperty.all<double>(30), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(14))),
                            onPressed: () {
                              ThemeProvider.controllerOf(context)
                                  .setTheme(e.id);
                              UserTelemetry()
                                      .currentModel
                                      .selectedTheme =
                                  ThemeClassifier.of(context).id;
                              UserTelemetry().save();
                            },
                            icon: Column(
                              children: <Widget>[
                                Icon(AvailableTheme.of(
                                  e.id,
                                ).icon),
                                const SizedBox(height: 6),
                                if (e.data.brightness ==
                                    Brightness.dark)
                                  const Icon(Icons.nightlight_round,
                                      size: 14)
                                else
                                  const Icon(Icons.wb_sunny_rounded,
                                      size: 14)
                              ],
                            ),
                            label: Text.rich(TextSpan(children: <InlineSpan>[
                              TextSpan(
                                  text: AvailableTheme.of(e.id)
                                      .properName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const TextSpan(text: "\nBy "),
                              TextSpan(
                                  text:
                                      AvailableTheme.of(e.id).author,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic))
                            ])))
                ],
              ),
            ]));
  }
}
