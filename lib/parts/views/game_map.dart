import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class GameMapView extends StatelessWidget
    implements AppPageViewExporter {
  const GameMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12)),
                child: Image.asset(
                  'assets/crescendo/labelled_map.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildButton(context, 'Starting Zone'),
          _buildButton(context, 'Speaker'),
          _buildButton(context, 'Source Area'),
          _buildButton(context, 'Amp Zone'),
          _buildButton(context, 'Stage'),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title button pressed')),
          );
        },
        child: Text(title),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // button color
          onPrimary: Colors.black, // Text color
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.map_rounded),
        icon: const Icon(Icons.map_outlined),
        label: "Game Map",
        tooltip: "View the Game Map"
      )
    );
  }
}
