import 'dart:convert';
import 'dart:io';

/// Means any class that exports this has the potential to export a CSV compatible data sheet. How they define the CSV layout is up to them.
abstract class QRCompatibleData<T> {
  String toCompatibleFormat();
}

mixin QRCompressedCompatibleDataBlob<T> on QRCompatibleData<T> {
  List<int> toCompressedCompatibleFormat() {
    return gzip.encode(utf8.encode(toCompatibleFormat()));
  }
}
