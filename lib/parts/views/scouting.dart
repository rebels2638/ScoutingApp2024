import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/team_model.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:scouting_app_2024/blobs/partition_blob.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context)
                  .size
                  .height, // Full height of the screen
              child: GridView.count(
                crossAxisCount:
                    2, // Set the number of columns as per your requirement
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio:
                    1.5, // Adjust the aspect ratio as needed
                children: <Widget>[
                  _section(context,
                      header: (
                        icon: Icons.numbers_rounded,
                        title: "Match Details"
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _txtfield(
                              prompt: "Match Number",
                              hint: "#",
                              inputType: TextInputType.number),
                          strut(width: 20),
                          Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              children: <Widget>[
                                const Text("Match Type",
                                    style: TextStyle(fontSize: 16)),
                                PartitionedBlob<MatchType>(
                                    preferredHeight: 140,
                                    preferredWidth: 350,
                                    onPressed:
                                        (MatchType type) /*TODO*/ {},
                                    crossAxisCount: 3,
                                    values: MatchType.values)
                              ]),
                        ],
                      )),
                  _section(context,
                      header: (
                        icon: Icons.numbers_rounded,
                        title: "Team Details"
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _txtfield(
                              prompt: "Team Number",
                              hint: "#",
                              inputType: TextInputType.number),
                          strut(width: 20),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.start,
                            children: <Widget>[
                              const Text("Starting Position",
                                  style: TextStyle(fontSize: 16)),
                              strut(height: 6),
                              PartitionedBlob<MatchStartingPosition>(
                                preferredHeight: 140,
                                preferredWidth: 350,
                                crossAxisCount: 3,
                                values: MatchStartingPosition.values,
                                onPressed: (MatchStartingPosition
                                    position) /*TODO*/ {},
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
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
        activeIcon: const Icon(Icons.data_thresholding_rounded),
        icon: const Icon(Icons.data_thresholding_outlined),
        label: "Scouting",
        tooltip: "Data collection screen for observing matches"
      )
    );
  }
}
