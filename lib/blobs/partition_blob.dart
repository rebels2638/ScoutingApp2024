import 'package:scouting_app_2024/debug.dart';
import "package:scouting_app_2024/blobs/locale_blob.dart";
import "package:theme_provider/theme_provider.dart";
import "package:flutter/material.dart";

class PartitionedBlob<T extends Enum> extends StatefulWidget {
  final int crossAxisCount;
  final List<T> values;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double preferredWidth;
  final double preferredHeight;
  final void Function(T result) onPressed;

  const PartitionedBlob(
      {super.key,
      this.preferredHeight = double.infinity,
      this.preferredWidth = double.infinity,
      this.crossAxisSpacing = 6,
      this.mainAxisSpacing = 6,
      required this.onPressed,
      required this.crossAxisCount,
      required this.values});

  @override
  State<PartitionedBlob<T>> createState() =>
      _PartitionedBlobState<T>();
}

class _PartitionedBlobState<T extends Enum>
    extends State<PartitionedBlob<T>> {
  int toggled = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.preferredHeight == double.infinity
          ? null
          : widget.preferredHeight,
      width: widget.preferredWidth == double.infinity
          ? null
          : widget.preferredWidth,
      child: GridView.builder(
        shrinkWrap: widget.preferredHeight == double.infinity ||
            widget.preferredWidth == double.infinity,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
        ),
        itemCount: widget.values.length,
        itemBuilder: (BuildContext context, int index) {
          return TextButton(
              style: toggled == index
                  ? ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ThemeProvider.themeOf(context)
                              .data
                              .colorScheme
                              .inversePrimary))
                  : null,
              onPressed: () {
                widget.onPressed.call(widget.values[index]);
                Debug().info(
                    "PartitionedBlob_$hashCode got $index to be toggled");
                setState(() => toggled = index);
              },
              child: Text(formalizeWord(widget.values[index].name)));
        },
      ),
    );
  }
}
