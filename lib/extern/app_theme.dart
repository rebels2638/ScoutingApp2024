import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

@immutable
class IntricateAppTheme extends AppTheme {
  final String author;
  final String canonicalName;
  final IconData icon;
  IntricateAppTheme(
      {required super.id,
      required super.data,
      required super.description,
      required this.author,
      required this.canonicalName,
      required this.icon});
}