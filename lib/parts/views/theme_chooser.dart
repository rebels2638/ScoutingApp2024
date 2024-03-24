import 'package:flutter/material.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/parts/theme_classifier.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class _ThemeSelectorTextFrame extends StatelessWidget {
  final String properName;
  final Color biContrast;
  final String author;
  final bool isDark;
  final bool isChecked;
  final IconData icon;
  final Color selectedColor;
  final List<Color> scheme;

  const _ThemeSelectorTextFrame(
      {required this.properName,
      required this.biContrast,
      required this.icon,
      required this.isChecked,
      required this.scheme,
      required this.selectedColor,
      required this.isDark,
      required this.author})
      : assert(scheme.length >
            0); // AND NOW YOU DONT WANT ME TO USE isNotEmpty and isEmpty ?? FUCK YOU DART!!!!

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      if (isChecked)
        const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.check_rounded)),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: isChecked ? selectedColor : biContrast, size: 24),
          Text.rich(
            TextSpan(children: <InlineSpan>[
              TextSpan(
                  text: " $properName",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
              if (author !=
                  "Builtin") // this is so fucking stupid bc its so hardcoded, but its also so necessary yet so unnecessary
                TextSpan(
                    text: "\n$author",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontStyle: FontStyle.italic))
            ]),
            style: TextStyle(
                color: isChecked ? selectedColor : biContrast),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (Color color in scheme)
                  Container(
                      margin: const EdgeInsets.only(
                          bottom: 6, left: 4, right: 4),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: color,
                          border:
                              Border.all(color: biContrast, width: 1),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                spreadRadius: 2,
                                color: color,
                                offset: const Offset(0, 1.4),
                                blurRadius: 8),
                          ]))
              ])
        ],
      ),
    ]);
  }
}

class ThemeChooserView extends StatelessWidget {
  final List<AppTheme> appThemes;

  const ThemeChooserView({super.key, required this.appThemes});

  @override
  Widget build(BuildContext context) {
    List<Widget> themeWidgets = <Widget>[];
    for (AppTheme e in appThemes) {
      bool checked = e.id != ThemeClassifier.of(context).id;
      _ThemeSelectorTextFrame t = _ThemeSelectorTextFrame(
          icon: AvailableTheme.of(e.id).icon ?? Icons.palette_rounded,
          isDark: e.data.brightness == Brightness.dark,
          isChecked: !checked,
          scheme: <Color>[
            e.data.colorScheme.primary,
            e.data.colorScheme.secondary,
            e.data.colorScheme.tertiary
          ],
          selectedColor: e.data.colorScheme.background.invert(),
          properName: AvailableTheme.of(e.id).properName,
          biContrast: e.data.primaryColor.biContrastingColor(),
          author: AvailableTheme.of(e.id).author);
      Widget x = checked
          ? ElevatedButton(
              style: ButtonStyle(
                  visualDensity: VisualDensity.comfortable,
                  backgroundColor: MaterialStateProperty.all<Color>(
                      e.data.primaryColor),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(14))),
              onPressed: () {
                ThemeProvider.controllerOf(context).setTheme(e.id);
                UserTelemetry().currentModel.selectedTheme =
                    ThemeClassifier.of(context).id;
                UserTelemetry().save();
              },
              child: t)
          : OutlinedButton(
              style: ButtonStyle(
                  visualDensity: VisualDensity.comfortable,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      e.data.iconTheme.color ?? Colors.black),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(14))),
              onPressed: () {
                ThemeProvider.controllerOf(context).setTheme(e.id);
                UserTelemetry().currentModel.selectedTheme =
                    ThemeClassifier.of(context).id;
                UserTelemetry().save();
              },
              child: t);

      themeWidgets.add(x);
    }
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: UserTelemetry().currentModel.showScrollbar),
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Row(children: <Widget>[
              const Icon(Icons.palette_rounded),
              const SizedBox(width: 10),
              Text("Theme Library (${appThemes.length})")
            ])),
        body: Padding(
          padding: const EdgeInsets.only(
              left: 8, right: 8, top: 12),
          child: GridView.count(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: themeWidgets,
          ),
        ),
      ),
    );
  }
}
