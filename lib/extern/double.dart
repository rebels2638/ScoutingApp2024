extension UsefulDouble on double {
  double clamp({required double max, required double min}) =>
      this > max
          ? max
          : this < min
              ? min
              : this;
}
