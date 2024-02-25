extension UsefulString on String {
  /// example string: "amogus" becomes "Amogus"
  String get formalize => this[0].toUpperCase() + substring(1);

  String getConstrained(int maxLength) {
    if (length > maxLength) {
      return "${substring(0, maxLength)}...";
    }
    return this;
  }
}
