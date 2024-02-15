/// Means any class that exports this has the potential to export a CSV compatible data sheet. How they define the CSV layout is up to them.
abstract class QRCompatibleData<T> {
  String toCompatibleFormat();

  // this method is very inefficient bc we cant directly suggest static methods in interfaces
  T fromCompatibleFormat(String csv);
}