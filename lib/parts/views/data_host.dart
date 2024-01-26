import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class DataHostingView extends StatelessWidget
    implements AppPageViewExporter {
  const DataHostingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[]);
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.connect_without_contact_rounded),
        icon: const Icon(Icons.connect_without_contact_outlined),
        label: "Data Host",
        tooltip: "Serving Hosting for the app data crunching"
      )
    );
  }
}
