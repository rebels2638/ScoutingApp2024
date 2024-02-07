import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/extern/community_material_icons.dart';
import 'package:scouting_app_2024/extern/flutter_icons.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/utils.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:yaml/yaml.dart';

// this file has caused me great pain... ~ exoad (2/6/2024)

class ThemeClassifier {
  static AvaliableTheme of(BuildContext context) {
    String name = ThemeProvider.themeOf(context).id;
    for (AvaliableTheme e in AvaliableTheme.export) {
      if (e.id == name) {
        return e;
      }
    }
    return AvaliableTheme.export[0];
  }
}

class AvaliableTheme {
  final String properName;
  final bool isDarkMode;
  final String author;
  late String id;
  final IconData? icon;

  AvaliableTheme(this.properName, this.id, this.icon, this.author,
      [this.isDarkMode = true]);

  static final List<AvaliableTheme> export = <AvaliableTheme>[
    /*
    AvaliableTheme.builtin("Default Dark"),
    AvaliableTheme.builtin("Default Light", false),
    AvaliableTheme.builtin("Mint", false),
    AvaliableTheme.builtin("Forest"),
    AvaliableTheme.builtin("Bamboo", false),
    AvaliableTheme.builtin("Peach", false),
    AvaliableTheme.builtin("Plum")
    */
  ];

  static AvaliableTheme of(String name) {
    for (AvaliableTheme theme in export) {
      if (theme.id == name) {
        return theme;
      }
    }
    Debug().warn(
        "Failed to search for a theme $name under AvaliabelTheme#of(String)");
    return export[0];
  }

  @override
  String toString() =>
      "Theme:{Name=$properName,IsDark=$isDarkMode,Id=$id}";
}

final class ThemeBlob {
  static ButtonStyle exportBtnBlobStyle() => ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8))));
  static const String THEME_LOCATION = "assets/themes/";

  static late List<AppTheme> _intricateThemes;

  static List<AppTheme> get intricateThemes => _intricateThemes;

  // dont worry about this function, ik it is very non idiot proof but we just try to 1984 that
  static Future<void> loadIntricateThemes() async {
    // get all .json files in the assets/themes folder
    // for each file, load the json and create a new AppTheme

    _intricateThemes = <AppTheme>[];
    dynamic rule = loadYaml(
        await rootBundle.loadString("assets/rules/themes.yml"));
    int i = 0;
    int f = 0;
    if (rule.runtimeType == YamlList && rule.length > 0) {
      for (dynamic x in rule) {
        if (x is YamlMap) {
          try {
            Debug().info(
                "Loading Theme: ${x['id']} made by ${x['author']}");
            ThemeData? theme = ThemeDecoder.decodeThemeData(
                jsonDecode(
                    await rootBundle.loadString(x['location'])));
            if (theme == null) {
              Debug().ohno("Failed to DECODE theme $x, skipping");
              f++;
            } else {
              // this might look like idiot proof code, but we have to add our own touch to mapping icons from static attributes to enums, just look at flutter_icons and community_material_icons D: it is very sad
              ThemeData better = theme.copyWith(
                textTheme: theme.textTheme
                    .apply(fontFamily: Shared.FONT_FAMILY_SANS),
                primaryTextTheme: theme.primaryTextTheme
                    .apply(fontFamily: Shared.FONT_FAMILY_SANS),
              );
              List<String> iconDescriptor = x['icon'].split(",");
              if (iconDescriptor.length == 2 &&
                  GenericUtils.matchesOfAny(iconDescriptor[0],
                      <String>["community", "flutter"])) {
                IconData? icon = Icons.palette_rounded;
                if (iconDescriptor[0] == "community") {
                  for (CommunityMaterialIconsEnumMapper v
                      in CommunityMaterialIconsEnumMapper.values) {
                    if (v.name == iconDescriptor[1]) {
                      icon = v.data;
                    }
                  }
                } else if (iconDescriptor[0] == "flutter") {
                  for (FlutterIconEnumMapper v
                      in FlutterIconEnumMapper.values) {
                    if (v.name == iconDescriptor[1]) {
                      icon = v.data;
                    }
                  }
                } else {
                  throw "'${iconDescriptor[0]}' is not a valid store to look for icons. Expecting 'community' or 'flutter'";
                }
                if (icon == null) {
                  throw "Failed to find the icon ${iconDescriptor[1]} under ${iconDescriptor[0]}! Make sure ${iconDescriptor[0] == "community" ? "lib/extern/community_material_icons.dart" : "lib/extern/flutter_icons.dart"} is properly updated!";
                }
                _intricateThemes.add(AppTheme(
                    id: x['id'],
                    data: better,
                    description:
                        "A ${better.brightness.name} theme"));
                AvaliableTheme.export.add(AvaliableTheme(
                    x['canonical_name'],
                    x['id'],
                    icon,
                    x['author'],
                    better.brightness == Brightness.dark));
                Debug().info(
                    "Registered: ${x['id']} to the intricate theme list!");
                i++;
              } else {
                Debug().ohno(
                    "Failed to load theme ${x['id']} because the 'icon' field does not follow '[community/flutter],[icon_name]' format!");
              }
            }
          } catch (e) {
            Debug().ohno("Failed to load a theme $x because of $e");
            f++;
          }
        } else {
          Debug().ohno(
              "Cannot proceed with $x because typeof($x) != YamlMap. Instead it is ${x.runtimeType}.");
        }
      }
      Debug().info("Loaded $i themes. Failed $f themes");
    }
  }

  static AppTheme _gen(
          {required String id, required ThemeData data}) =>
      AppTheme(
          id: id.toLowerCase().replaceAll(" ", "_"),
          data: data,
          description: id);

  static Future<void> loadBuiltinThemes() async {
    ThemeData? theme = ThemeDecoder.decodeThemeData(jsonDecode(
        await rootBundle.loadString("assets/default_dark.json")));
    if (theme != null) {
      ThemeData better = theme.copyWith(
        textTheme: theme.textTheme
            .apply(fontFamily: Shared.FONT_FAMILY_SANS),
        primaryTextTheme: theme.primaryTextTheme
            .apply(fontFamily: Shared.FONT_FAMILY_SANS),
      );
      export.add(_gen(id: "Default Dark", data: better));
      AvaliableTheme.export.add(AvaliableTheme("Default Dark",
          "default_dark", Icons.palette_rounded, "Builtin", true));
    } else {
      throw "BUG WITH LOADING DEFAULT THEME! 049";
    }
  }

  static List<AppTheme> export = <AppTheme>[
    /*
        _gen(
            id: "Default Light",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: Shared.FONT_FAMILY_SANS,
                colorScheme: lightColorScheme3)),
        _gen(
            id: "Bamboo",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: Shared.FONT_FAMILY_SANS,
                colorScheme: matcha)),
        _gen(
            id: "Mint",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: Shared.FONT_FAMILY_SANS,
                colorScheme: lightColorScheme)),
        _gen(
            id: "Forest",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: Shared.FONT_FAMILY_SANS,
                colorScheme: darkColorScheme
                )),
        _gen(
            id: "Peach",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: Shared.FONT_FAMILY_SANS,
                colorScheme: lightColorScheme2)),
        _gen(
            id: "Plum",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: Shared.FONT_FAMILY_SANS,
                colorScheme: darkColorScheme2)),
                */
  ];
}
