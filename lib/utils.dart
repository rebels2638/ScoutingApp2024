import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scouting_app_2024/debug.dart';

typedef pair<A, B> = (A first, B second);

class GenericUtils {
  static List<bool> boolOptions() => const <bool>[true, false];

  static bool matchesOfAny<T>(T interest, List<T> content) {
    for (T e in content) {
      if (e == interest) {
        return true;
      }
    }
    return false;
  }

  static String repeatStr(String r, int reps) {
    // this if detection might be overcomplicated
    if (reps == 0) {
      return "";
    }
    if (reps == 1) {
      return r;
    }
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < reps; i++) {
      buffer.write(r);
    }
    return buffer.toString();
  }

  static const String HAZARD_DIAMOND = "◢◤";

  static String jsonToCsvSingle(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    StringBuffer csvData = StringBuffer();
    for (String key in map.keys) {
      csvData.write("$key,${map[key]}\n");
    }
    return csvData.toString();
  }

  /// follows that [json] is in the format of "[{...}]"
  static String jsonToCsvMulti1(String json) {
    List<dynamic> map = jsonDecode(json);
    StringBuffer csvData = StringBuffer();
    List<String> heads = map[0].keys.toList();
    csvData.writeAll(heads, ",");
    csvData.write("\n");
    for (Map<String, dynamic> row in map) {
      for (String head in heads) {
        csvData.write("${row[head]},");
      }
      csvData.write("\n");
    }
    return csvData.toString();
  }
}

class LocaleUtils {
  static late final Set<String> RANDOM_WORDS;

  static void loadWordsRules() async {
    Debug().info("Loading RANDOM_WORDS_RULE");
    RANDOM_WORDS = <String>{};
    for (String word
        in (await rootBundle.loadString("assets/rules/words.txt"))
            .split("\n")) {
      RANDOM_WORDS.add(word.toLowerCase().trim());
    }
  }
}
