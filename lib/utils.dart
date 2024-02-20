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
