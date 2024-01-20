int clampInt(int i, {required int max, required int min}) => i > max
    ? max
    : i < min
        ? min
        : i;
