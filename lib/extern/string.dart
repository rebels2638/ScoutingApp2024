extension UsefulString on String {
  /// example string: "amogus" becomes "Amogus"
  String get formalize => this[0].toUpperCase() + substring(1);
}
