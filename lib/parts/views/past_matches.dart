import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import "package:scouting_app_2024/blobs/form_blob.dart";
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

import 'match_tile.dart';

class PastMatchesView extends StatefulWidget
    implements AppPageViewExporter {
  const PastMatchesView({super.key});

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.receipt_rounded),
        icon: const Icon(Icons.receipt_outlined),
        label: "History",
        tooltip: "View data collected from past matches"
      )
    );
  }

  @override
  State<PastMatchesView> createState() => _PastMatchesViewState();
}

class _PastMatchesViewState extends State<PastMatchesView> {
  late QrImage qrImage;
  List<HollisticMatchScoutingData> matches =
      <HollisticMatchScoutingData>[];
  final List<String> _matchIdsCache = <String>[];
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

//this is all from team_model.dart
  void loadMatches() {
    // todo, below just placeholder data
    Debug().info(
        "PAST_MATCHES: Loading ${ScoutingTelemetry().length} past matches");
    ScoutingTelemetry()
        .forEachHollistic((HollisticMatchScoutingData match) {
      if (!_matchIdsCache.contains(match.id)) {
        Debug().info("PAST_MATCHES: Adding match ${match.id}");
        matches.add(match);
        _matchIdsCache.add(match.id);
      } else {
        Debug().warn(
            "PAST_MATCHES: Match ${match.id} already exists! Ignoring it");
      }
    });
    setState(() {});
  }

  Future<void> removeMatch(String id) async {
    setState(() {
      matches
          .removeWhere((HollisticMatchScoutingData m) => m.id == id);
    });
    _matchIdsCache.removeWhere((String m) => m == id);
    await ScoutingTelemetry().deleteID(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Icon(Icons.calendar_month),
                    SizedBox(width: 8.0),
                    Text("Past Matches",
                        style: TextStyle(fontSize: 20.0)),
                  ],
                ),
                Row(
                  children: strutAll(<Widget>[
                    IconButton.filledTonal(
                        icon: _sortAscending
                            ? const Icon(Icons.arrow_upward_rounded)
                            : const Icon(
                                Icons.arrow_downward_rounded),
                        onPressed: () {
                          setState(() {
                            _sortAscending = !_sortAscending;
                            matches.sort((HollisticMatchScoutingData
                                        a,
                                    HollisticMatchScoutingData b) =>
                                _sortAscending
                                    ? a.preliminary.timeStamp
                                        .compareTo(
                                            b.preliminary.timeStamp)
                                    : b.preliminary.timeStamp
                                        .compareTo(
                                            a.preliminary.timeStamp));
                          });
                        }),
                    IconButton.filledTonal(
                        onPressed: () => loadMatches(),
                        icon: const Icon(Icons.refresh_rounded)),
                    IconButton.filledTonal(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () async =>
                            await launchAssuredConfirmDialog(context,
                                message:
                                    "Are you sure you want to DELETE ALL ${matches.length} entries?",
                                title:
                                    "Delete ${matches.length} entries",
                                onConfirm: () {
                              setState(() {
                                matches.clear();
                              });
                              _matchIdsCache.clear();
                              ScoutingTelemetry().clear();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "All past matches deleted. Cleare")),
                              );
                            })),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.download),
                      onPressed: () async {
                        /*
                        String exportData = matches
                            .map((PastMatchesOverViewData match) =>
                                matchDataToCsv(match))
                            .join("\n");
                        Widget qrWidget = createPrettyQrDataWidget(
                          data: exportData,
                          includeImage: false,
                        );
                        await launchConfirmDialog(
                          showOkLabel: false,
                          denyLabel: "Close",
                          icon: const Icon(Icons.cloud_sync),
                          title:
                              "Transfer All Scouting Data via QR Code",
                          context,
                          message: qrWidget,
                          onConfirm: () {},
                        );
                        */
                      },
                    ),
                  ], width: 14),
                ),
              ],
            ),
          ),
          Expanded(
              child: matches.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(CommunityMaterialIcons.emoticon_sad,
                            color: ThemeProvider.themeOf(context)
                                .data
                                .appBarTheme
                                .foregroundColor,
                            size: 64),
                        const SizedBox(height: 18),
                        // this is so badly optimized because we are calling a non compile const ThemeProvider.themeOf
                        Text.rich(
                            const TextSpan(children: <InlineSpan>[
                              TextSpan(
                                  text:
                                      "No past matches found...\n\n",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "Hint: \"maybe go scout a team?\" ~ Jack",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic))
                            ]),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ThemeProvider.themeOf(context)
                                    .data
                                    .appBarTheme
                                    .foregroundColor))
                      ],
                    ))
                  : PreferCompactModal.isCompactPreferred(context)
                      ? Builder(
                          builder: (BuildContext context) {
                            List<Widget> widgets = <Widget>[];
                            for (HollisticMatchScoutingData match
                                in matches) {
                              Debug().info(
                                  "PAST_MATCHES: Adding match ${match.id}");
                              widgets.add(MatchTile(
                                match: match,
                                onDelete: removeMatch,
                              ));
                            }
                            return form_grid_2(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              children: widgets,
                            );
                          },
                        )
                      : RefreshIndicator(
                          onRefresh: () async =>
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 750),
                                  () => loadMatches()),
                          displacement: 20,
                          child: ListView.builder(
                            physics:
                                const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(
                                        decelerationRate:
                                            ScrollDecelerationRate
                                                .normal)),
                            padding:
                                const EdgeInsets.only(bottom: 40),
                            itemCount: matches.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return MatchTile(
                                match: matches[index],
                                onDelete: removeMatch,
                              );
                            },
                          ),
                        )),
        ],
      ),
    );
  }
}