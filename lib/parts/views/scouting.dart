import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/team_model.dart';
import 'package:theme_provider/theme_provider.dart';

typedef SectionId = ({String title, IconData icon});

class ScoutingView extends StatelessWidget
    implements AppPageViewExporter {
  const ScoutingView({super.key});

  /// blob func
  static Widget _section(BuildContext context,
          {required SectionId header, required Widget child}) =>
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ThemeProvider.themeOf(context)
                .data
                .colorScheme
                .onInverseSurface),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(header.icon, size: 26),
                strut(width: 6),
                Text(header.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))
              ]),
              strut(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: child,
              ),
            ],
          ),
        ),
      );

  /// blob func
  static Widget _txtfield({
    required String prompt,
    String? hint,
    String? label,
    Icon? prefixIcon,
    Icon? suffixIcon,
    double width = 100,
    void Function(String)? onChanged,
    TextInputType? inputType,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(prompt, style: const TextStyle(fontSize: 16)),
          strut(height: 6),
          SizedBox(
            width: width,
            child: TextFormField(
              onChanged: (String e) => onChanged?.call(e),
              keyboardType: inputType,
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                suffix: suffixIcon,
                labelText: label,
                hintText: hint,
                border: const OutlineInputBorder(gapPadding: 0),
              ),
            ),
          ),
        ],
      );

  /// blob func
  static Widget _dropdown<T extends Enum>(
          {required String prompt,
          required List<DropdownMenuEntry<T>> entries,
          required String label,
          required void Function(T? result) onSelected}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(prompt, style: const TextStyle(fontSize: 16)),
          strut(height: 6),
          DropdownMenu<T>(
            dropdownMenuEntries: entries,
            label: Text(label),
            initialSelection: entries.first.value,
            requestFocusOnTap: true,
            onSelected: onSelected,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // MOCKUP, NOT FINAL
    return CustomScrollView(slivers: <Widget>[
      SliverToBoxAdapter(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            strut(width: 20),
            Flexible(
              flex: 2,
              child: _section(context,
                  header: (
                    icon: Icons.numbers_rounded,
                    title: "Match Details"
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _txtfield(
                          prompt: "Match Number",
                          hint: "#",
                          inputType: TextInputType.number),
                      strut(height: 10),
                      PartitionedBlob<MatchType>(
                          preferredHeight: 140,
                          preferredWidth: 350,
                          onPressed: (_) {},
                          crossAxisCount: 3,
                          values: MatchType.values),
                    ],
                  )),
            ),
            strut(width: 14),
            Flexible(
              flex: 2,
              child: _section(context,
                  header: (
                    icon: Icons.numbers_rounded,
                    title: "Team Details"
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _txtfield(
                          prompt: "Team Number",
                          hint: "#",
                          inputType: TextInputType.number),
                      strut(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Text("Starting Position",
                              style: TextStyle(fontSize: 16)),
                          strut(height: 6),
                          PartitionedBlob<MatchStartingPosition>(
                            preferredHeight: 100,
                            preferredWidth: 250,
                            crossAxisCount: 3,
                            values: MatchStartingPosition.values,
                            onPressed: (_) {},
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.data_thresholding_rounded),
        icon: const Icon(Icons.data_thresholding_outlined),
        label: "Scouting",
        tooltip: "Data collection screen for observing matches"
      )
    );
  }
}
