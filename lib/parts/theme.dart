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

class AvailableTheme {
  final String properName;
  final bool isDarkMode;
  final String author;
  late String id;
  final IconData? icon;

  AvailableTheme(this.properName, this.id, this.icon, this.author,
      [this.isDarkMode = true]);

  static final List<AvailableTheme> export = <AvailableTheme>[];

  static AvailableTheme of(String name) {
    for (AvailableTheme theme in export) {
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

  static List<AppTheme> _intricateThemes = <AppTheme>[];

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
    if (rule.runtimeType == YamlList && rule.isNotEmpty) {
      await Future.forEach(rule, (dynamic x) async {
        if (x is YamlMap) {
          try {
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
                AvailableTheme.export.add(AvailableTheme(
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
      });
    }
    Debug().info("Loaded $i themes. Failed $f themes");
  }

  static AppTheme _gen(
          {required String id, required ThemeData data}) =>
      AppTheme(
          id: id.toLowerCase().replaceAll(" ", "_"),
          data: data,
          description: id);

  static Future<void> loadBuiltinThemes() async {
    const List<String> builtinThemes = <String>[
      "Default Dark",
      "Default Dark 2",
      "Default Light",
      "Default Light 2"
    ];
    int i = 0;
    for (String r2 in builtinThemes) {
      String r = r2.toLowerCase().replaceAll(" ", "_");
      ThemeData? theme = ThemeDecoder.decodeThemeData(
          jsonDecode(await rootBundle.loadString("assets/$r.json")));
      if (theme != null) {
        ThemeData better = theme.copyWith(
          textTheme: theme.textTheme
              .apply(fontFamily: Shared.FONT_FAMILY_SANS),
          primaryTextTheme: theme.primaryTextTheme
              .apply(fontFamily: Shared.FONT_FAMILY_SANS),
        );
        export.add(_gen(id: r, data: better));
        AvailableTheme.export.add(AvailableTheme(
            r2, r, Icons.palette_rounded, "Builtin", true));
      } else {
        throw "BUG WITH LOADING DEFAULT THEME! 049_$i";
      }
      i++;
      Debug().info("Loaded builtin theme: $r");
    }
  }

  static List<AppTheme> export = <AppTheme>[];
}
