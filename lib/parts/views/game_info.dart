import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class GameInfoView extends StatelessWidget
    implements AppPageViewExporter {
  const GameInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Labelled Game Field',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            FittedBox(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset('assets/crescendo/labelled_map.png',
                      width: 580),
                  Tooltip(
                    message: "Zoom in on game field",
                    child: FilledButton.tonal(
                        onPressed: () async =>
                            await launchConfirmDialog(context,
                                onConfirm: () {},
                                title: "Game Field",
                                showOkLabel: false,
                                message: Scaffold(
                                  body: PhotoView(
                                      initialScale:
                                          PhotoViewComputedScale
                                              .covered,
                                      imageProvider: const AssetImage(
                                          'assets/crescendo/labelled_map.png')),
                                )),
                        child: const Icon(Icons.zoom_in_rounded)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Game Items',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              children: <String>['Notes', 'High Notes']
                  .map((String title) =>
                      _buildButton(context, title,isGameItem: true, isGameLocation: false, isGamePhase: false))
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
              ]
                  .map((String title) => _buildButton(context, title, isGameItem: false, isGameLocation: true, isGamePhase: false))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Game Phases',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              children: <String>[
                'Autonomous',
                'Teleop',
                'Endgame',
              ]
                  .map((String title) => _buildButton(context, title,isGameItem: false, isGameLocation: false, isGamePhase: true))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title,
      {bool isGameItem = false ,bool isGameLocation = false, required bool isGamePhase}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 8),
      child: Container(
        constraints:
            const BoxConstraints(maxWidth: 200, maxHeight: 70),
        child: preferTonalButton(
          onPressed: () => _showDetails(context, title),
          icon: Icon(
              isGameItem ? Icons.build : isGameLocation ? Icons.location_on_rounded : isGamePhase ? Icons.timer : Icons.man_2 ),
          style: FilledButton.styleFrom(elevation: 2),
          label: Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, String title) {
    final Map<String, String> details = <String, String>{
      'Starting Zone':
          'Where robots start at the beginning of the match before the autonomous period.\n\nAutonomous:\n• 2pts: Robot leaves starting zone',
      'Stage':
          '• During the match, robots can score additional points by parking in their Stage Zone, getting Onstage via a chain, or scoring a Note in a Trap. \n \nPoints vary for being Onstage with or without the Spotlight per robot.\n• 3pts: Spotlight\n• 4pts: Spotlight during Teleop phase)\n• 5pts: Note scored in a trap on stage.\n\n• Harmony is achieved when more than one robot is Onstage via the same chain, giving 2 ranking points.',
      'Source Area':
          'Where Notes are introduced into the field for robots to collect.',
      'Amp Zone':
          'During Auto and Tele-op, robots score Notes in the Amp zone, which can give benefits.\n\n• For 2 notes scored in Amp: human players can activate a 10 sec points multiplier for Notes scored in their Speaker\n\nCoopertition:\n• Each alliance scores 1 in Amp and presses Coopertition button\n• 1 Coopertition point (Ranking Point)\n• Reduced point requirement for Melody/bonus point\n\nAuto:\n• 2pts: Note scored in Amp\n\nTele-op:\n• 1pts: Note scored in Amp\n• 5pts: Note scored in Speaker (after Amp activation)',
      'Speaker':
          'Notes are scored in the Speaker with different points awarded based on whether they are Amplified or not.\n\nAutonomous:\n• 5pts: Normal Note\n\nTele-op:\n• 2pts: Normal Note\n• 5pts: Amped Note',
      'High Notes':
          '• High note - special game piece\n\n• Spotlighting - when High Note scored on Microphone when 1 or more robots are on stage.\n• During Spotlight, every note scored in the trap will be granted one additional point (max 3) .',
      'Notes':
          '• Note - primary game piece\n• Scored in Speaker and Amp for points',
      'Autonomous':'First phase of the match (15 Seconds Long)\n\nRobots operate with only their pre-programmed instructions with no human control\n\nRobots are pre-loaded with one note and may control no more than one note at a time\n\nRobots can score in either the Speaker (5 points) or Amp (2 points)',
      'Teleop':'Second Phase of the match (2 Minutes and 15 Seconds Long)\n\nRobots operated by drive team and can score in the Speaker (2 Points or 5 Points if amplified)\n\nRobots can score 2 notes in the Amplifier(1 point and choice between increased points for scoring in the Speaker or Coopertition Bonus)',
      'Endgame':'Final Phase of the match (20 Seconds Long)\n\nRobots climb chains to get on Stage(3 Points) and score in the trap(5 points)\n\nIf Two Robots are on the same chain they achieve Harmony (2 Points) \n\nHuman Players Spotlight robots on Stage by throwing high notes onto Microphone (Increase points for Robots on Stage to 4 Points)\n\nRobots can go under the Stage to Park (1 Point)',
    };

    final Map<String, IconData> icons = <String, IconData>{
      'Starting Zone': Icons.flag,
      'Stage': Icons.theater_comedy,
      'Source Area': Icons.source,
      'Amp Zone': Icons.volume_up,
      'Speaker': Icons.speaker,
      'High Notes': Icons.music_note,
      'Notes': Icons.music_note,
      'Autonomous': Icons.settings_rounded,
      'Teleop':Icons.person_2_rounded,
      'Endgame':Icons.outlined_flag_rounded
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
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    details[title] ??
                        'Details for "$title" are not available.',
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
