extension UsefulInt on int {
  bool outside({required int max, required int min}) =>
      this > max || this < min;
}
