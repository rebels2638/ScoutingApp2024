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
