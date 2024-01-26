import 'dart:io';

extension UsefulPlatform on Platform {
  static bool isDesktop() =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;
}
