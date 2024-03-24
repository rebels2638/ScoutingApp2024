/// An expressive way to handle null checks
///
/// If you want to get the value, please use dart's cascade operator
/// ```
/// (await pollDelegator()) // pollDelegator returns Future<Option<...,String>>
///   ..onBad((reason) => print(reason))
///   ..onGood((value) => sendToDataBase(value));
/// ```
///
/// i love this very much (brings back the good old memories of java verbosity!)
final class Option<A, B> {
  final A? _value;
  final B reason;

  const Option.good({A? value, required this.reason})
      : _value = value;

  /// oops! the data is gone!?!?
  const Option.fuckedUp({required this.reason}) : _value = null;

  bool get isBad => _value == null;

  void onBad(void Function(B reason) fx) {
    if (isBad) {
      fx.call(reason);
    }
  }

  void onGood(void Function(A value) fx) {
    if (_value != null) {
      fx.call(_value);
    }
  }
}
