import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouting_app_2024/parts/avatar_representator.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_hints.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import "package:scouting_app_2024/blobs/form_blob.dart";
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
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
        activeIcon: const Icon(Icons.collections_bookmark_rounded),
        icon: const Icon(Icons.collections_bookmark_outlined),
        label: "Data",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          maintainState: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          subtitle: ShowHintsGuideModal.isShowingHints(context)
              ? const Row(
                  children: <Widget>[
                    Icon(Icons.touch_app_rounded, size: 14),
                    SizedBox(width: 8),
                    Text("Click here to view your profile",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic)),
                  ],
                )
              : null,
          childrenPadding: const EdgeInsets.all(12),
          title: const Text("User Profile",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .appBarTheme
                        .backgroundColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 16),
                        child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: <Widget>[
                              const GlowingAvatarRepresentator(
                                  glowSpreadRadius: 6,
                                  glowBlurRadius: 10,
                                  width: 116,
                                  height: 116),
                              const Spacer(),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      UserTelemetry()
                                          .currentModel
                                          .profileName,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                          overflow:
                                              TextOverflow.ellipsis)),
                                  const SizedBox(height: 8),
                                  Row(children: <Widget>[
                                    const Icon(
                                        Icons.calendar_today_rounded,
                                        size: 12),
                                    const SizedBox(width: 6),
                                    Text(
                                        "Scouted ${matches.length} Match${matches.length != 1 ? "es" : ""}", // very sophisticated pluralization and zero bs checking
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.w300,
                                            fontStyle:
                                                FontStyle.italic,
                                            color: ThemeProvider
                                                    .themeOf(context)
                                                .data
                                                .appBarTheme
                                                .foregroundColor)),
                                  ]),
                                  const SizedBox(height: 8),
                                  FilledButton.tonal(
                                      onPressed: () async =>
                                          await launchInformDialog(
                                              context,
                                              title: UserTelemetry()
                                                  .currentModel
                                                  .profileName,
                                              message: Text.rich(TextSpan(
                                                  children: <InlineSpan>[
                                                    const TextSpan(
                                                        text:
                                                            "Identifier\n",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            fontSize:
                                                                18)),
                                                    TextSpan(
                                                        text: UserTelemetry()
                                                            .currentModel
                                                            .profileId,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300,
                                                            fontFamily:
                                                                "Monospace")),
                                                  ]))),
                                      child: const Text("More Info",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.w300))),
                                ],
                              )
                            ]))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            children: <Widget>[
              IconButton.filledTonal(
                  icon: _sortAscending
                      ? const Icon(Icons.arrow_upward_rounded)
                      : const Icon(Icons.arrow_downward_rounded),
                  onPressed: () {
                    setState(() {
                      _sortAscending = !_sortAscending;
                      matches.sort((HollisticMatchScoutingData a,
                              HollisticMatchScoutingData b) =>
                          _sortAscending
                              ? a.preliminary.timeStamp
                                  .compareTo(b.preliminary.timeStamp)
                              : b.preliminary.timeStamp.compareTo(
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
                          title: "Delete ${matches.length} entries",
                          onConfirm: () {
                        setState(() {
                          matches.clear();
                        });
                        _matchIdsCache.clear();
                        ScoutingTelemetry().clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("All past matches deleted!")),
                        );
                      })),
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
                                text: "No past matches found...\n\n",
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
                        // this could be optimized further with a futurebuilder
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
                          padding: const EdgeInsets.only(bottom: 40),
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
    );
  }
}
