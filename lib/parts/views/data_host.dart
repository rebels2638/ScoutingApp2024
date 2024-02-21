import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class DataHostingView extends StatefulWidget
    implements AppPageViewExporter {
  const DataHostingView({super.key});

  @override
  State<DataHostingView> createState() => _DataHostingViewState();

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

class _DataHostingViewState extends State<DataHostingView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("Data Host",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.black),
                        Text(
                            "Only use this if you know what you are doing or you are a [Scouting Leader]",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ]),
    );
  }
}
