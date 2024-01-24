extension UsefulInt on int {
  int clamp({required int max, required int min}) => this > max
      ? max
      : this < min
          ? min
          : this;
}
