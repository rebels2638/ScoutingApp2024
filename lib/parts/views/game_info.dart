import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class GameInfoView extends StatelessWidget implements AppPageViewExporter {
  const GameInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Labelled Game Field',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Image.asset(
              'assets/crescendo/labelled_map.png',
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              'Game Items',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              children: <String>['Notes', 'High Notes']
                  .map((String title) => _buildButton(context, title, isGameItem: true))
                  .toList(),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Game Locations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              children: <String>[
                'Starting Zone',
                'Speaker',
                'Source Area',
                'Amp Zone',
                'Stage',
              ].map((String title) => _buildButton(context, title)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, {bool isGameItem = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 8),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 70),
        child: FilledButton.tonalIcon(
          onPressed: () => _showDetails(context, title),
          icon: Icon(isGameItem ? Icons.build : Icons.location_on_rounded),
          style: FilledButton.styleFrom(elevation: 2),
          label: Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, String title) {
    final Map<String, String> details = <String, String>{
      'Starting Zone': 'Where robots start at the beginning of the match before the autonomous period.\n\nAutonomous:\n• 2pts: Robot leaves starting zone',
      'Stage': '• During the match, robots can score additional points by parking in their Stage Zone, getting Onstage via a chain, or scoring a Note in a Trap. \n \nPoints vary for being Onstage with or without the Spotlight per robot (3 points without Spotlight, 4 points with Spotlight during Teleop phase), and a note scored in a trap on stage are 5 points. \n \nHarmony is achieved when more than one robot is Onstage via the same chain, giving 2 ranking points.',
      'Source Area': 'Where Notes are introduced into the field for robots to collect.',
      'Amp Zone': 'During Auto and Tele-op, robots score Notes in the Amp zone, which can give benefits.\n\n• For 2 notes scored in Amp: human players can activate a 10 sec points multiplier for Notes scored in their Speaker\n\nCoopertition:\n• Each alliance scores 1 in Amp and presses Coopertition button\n• 1 Coopertition point (Ranking Point)\n• Reduced point requirement for Melody/bonus point\n\nAuto:\n• 2pts: Note scored in Amp\n\nTele-op:\n• 1pts: Note scored in Amp\n• 5pts: Note scored in Speaker (after Amp activation)',
      'Speaker': 'Notes are scored in the Speaker with different points awarded based on whether they are Amplified or not.\n\nAutonomous:\n• 5pts: Normal Note\n\nTele-op:\n• 2pts: Normal Note\n• 5pts: Amped Note',
      'High Notes': 'High note - special game piece\n\nWhen a High Note is scored on a Microphone when one robot or more is on stage, it Spotlights Robots Onstage, granting one additional point per high note scored (max of 3).',
      'Notes': 'Note - game piece\n\nThe primary game piece scored in the Speaker and Amp for points.\n\nIf a Note is placed in a Trap, it gives a maximum of one per Trap, awarding 5 points during Teleop.',
    };

    final Map<String, IconData> icons = <String, IconData>{
    'Starting Zone': Icons.flag,
    'Stage': Icons.theater_comedy,
    'Source Area': Icons.source,
    'Amp Zone': Icons.volume_up,
    'Speaker': Icons.speaker,
    'High Notes': Icons.music_note,
    'Notes': Icons.music_note,
  };

  IconData icon = icons[title] ?? Icons.help_outline;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, size: 26),
                  const SizedBox(width: 10),
                  Text(title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    details[title] ?? 'Details for "$title" are not available.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
        label: "Game Info",
        tooltip: "View Game Info"
      )
    );
  }
}