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
}
