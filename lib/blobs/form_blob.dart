import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:theme_provider/theme_provider.dart';

class _BetterGridLayout extends SliverGridLayout {
  final int crossAxisCount;
  final double dim;
  final int fullRowPeriod;
  final int loopLength;
  final double loopHeight;

  const _BetterGridLayout({
    required this.crossAxisCount,
    required this.dim,
    required this.fullRowPeriod,
  })  : assert(crossAxisCount > 0),
        assert(fullRowPeriod > 1),
        loopLength = crossAxisCount * (fullRowPeriod - 1) + 1,
        loopHeight = fullRowPeriod * dim;

  @override
  double computeMaxScrollOffset(int childCount) =>
      childCount == 0 || dim == 0
          ? 0
          : (childCount ~/ loopLength) * loopHeight +
              ((childCount % loopLength) ~/ crossAxisCount) * dim;
  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int loop = index ~/ loopLength;
    final int loopIndex = index % loopLength;
    if (loopIndex == loopLength - 1) {
      return SliverGridGeometry(
        scrollOffset: (loop + 1) * loopHeight - dim,
        crossAxisOffset: 0,
        mainAxisExtent: dim,
        crossAxisExtent: crossAxisCount * dim,
      );
    }
    return SliverGridGeometry(
      scrollOffset:
          (loop * loopHeight) + (loopIndex ~/ crossAxisCount * dim),
      crossAxisOffset: loopIndex % crossAxisCount * dim,
      mainAxisExtent: dim,
      crossAxisExtent: dim,
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) =>
      ((scrollOffset ~/ dim) ~/ fullRowPeriod) * loopLength +
      ((scrollOffset ~/ dim) % fullRowPeriod) * crossAxisCount;

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int rows = scrollOffset ~/ dim;
    final int extra = rows % fullRowPeriod;
    if (extra == fullRowPeriod - 1) {
      return rows ~/ fullRowPeriod * loopLength +
          extra * crossAxisCount;
    }
    return (rows ~/ fullRowPeriod * loopLength +
            extra * crossAxisCount) +
        crossAxisCount -
        1;
  }
}

class _BetterGridDelegate extends SliverGridDelegate {
  final double dim;
  _BetterGridDelegate({required this.dim});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    int count = constraints.crossAxisExtent ~/ dim;
    if (count < 1) {
      count = 1;
    }
    final double squaredim = constraints.crossAxisExtent / count;
    return _BetterGridLayout(
      crossAxisCount: count,
      fullRowPeriod: 3,
      dim: squaredim,
    );
  }

  @override
  bool shouldRelayout(_BetterGridDelegate oldDelegate) =>
      dim != oldDelegate.dim;
}

typedef SectionId = ({String title, IconData icon});

@pragma("vm:prefer-inline")
Widget form_grid_1(
        {int? itemCount,
        required List<Widget> children,
        double dim = 240}) =>
    GridView.builder(
        gridDelegate: _BetterGridDelegate(dim: dim),
        itemCount: itemCount ?? children.length,
        itemBuilder: (BuildContext context, int index) =>
            GridTile(child: children[index]));

@pragma("vm:prefer-inline")
Widget form_grid_sec(BuildContext context,
        {required SectionId header,
        Gradient? gradient,
        Color? color,
        required Widget child}) =>
    Container(
        margin: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            gradient: gradient,
            color: color ??
                ThemeProvider.themeOf(context)
                    .data
                    .colorScheme
                    .onInverseSurface),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(header.icon, size: 36),
                  strut(width: 10),
                  Text(header.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))
                ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                )
              ]),
        ));

@pragma("vm:prefer-inline")
Widget form_sec(BuildContext context,
        {required SectionId header, required Widget child}) =>
    Container(
        decoration: BoxDecoration(
            color: ThemeProvider.themeOf(context)
                .data
                .colorScheme
                .onInverseSurface,
            borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(header.icon, size: 36),
                  strut(width: 10),
                  Text(header.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))
                ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                )
              ]),
        ));

@pragma("vm:prefer-inline")
Widget form_seg_btn_1<T>(
        {required List<({T value, String label, Icon? icon})>
            segments,
        required T initialSelection,
        required void Function(T res) onSelect}) =>
    SegmentedButton<T>(
        segments: <ButtonSegment<T>>[
          for (({T value, String label, Icon? icon}) e in segments)
            ButtonSegment<T>(
                value: e.value, label: Text(e.label), icon: e.icon)
        ],
        selected: <T>{
          initialSelection
        },
        onSelectionChanged: (Set<T> values) =>
            onSelect.call(values.first));

@pragma("vm:prefer-inline")
Widget form_txtin({
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
