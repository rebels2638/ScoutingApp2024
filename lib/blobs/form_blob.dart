import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
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

const double _prompt_label_strut_width = 10;

class _NumPickBtn extends StatefulWidget {
  final int maxValue;
  final int minValue;
  final int itemCount;
  final bool infiniteLoop;
  final Axis? alignment;
  final void Function(int res) onChange;
  final String label;
  final Icon icon;
  final Icon? headerIcon;
  final String headerMessage;
  final String? comment;

  const _NumPickBtn(
      {required this.label,
      required this.icon,
      this.headerIcon,
      required this.itemCount,
      required this.minValue,
      required this.maxValue,
      this.infiniteLoop = true,
      this.alignment = Axis.vertical,
      required this.headerMessage,
      this.comment,
      required this.onChange});

  @override
  State<_NumPickBtn> createState() => _NumPickBtnState();
}

class _NumPickBtnState extends State<_NumPickBtn> {
  late int _initValue;

  @override
  void initState() {
    super.initState();
    _initValue = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      FilledButton.icon(
          icon: widget.icon,
          label: Text(widget.label),
          onPressed: () async => await launchNumberPickerDialog(
                  context,
                  maxValue: widget.maxValue.abs(),
                  minValue: widget.minValue.abs(),
                  headerIcon: widget.headerIcon,
                  headerMessage: widget.headerMessage,
                  alignment: widget.alignment,
                  itemCount: widget.maxValue.abs().toString().length,
                  infiniteLoop: widget.infiniteLoop,
                  comment: widget.comment, onChange: (int value) {
                setState(() => _initValue = value);
                widget.onChange.call(value);
              })),
      strut(width: 6),
      Text.rich(TextSpan(children: <InlineSpan>[
        const TextSpan(text: " = "),
        TextSpan(
            text: _initValue == -1 ? "Unset" : _initValue.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold))
      ]))
    ]);
  }
}

@pragma("vm:prefer-inline")
Widget form_numpick(BuildContext context,
        {required String label,
        required Icon icon,
        Icon? headerIcon,
        required int minValue,
        required int maxValue,
        bool infiniteLoop = true,
        Axis alignment = Axis.vertical,
        required String headerMessage,
        String? comment,
        required void Function(int res) onChange}) =>
    _NumPickBtn(
        label: label,
        icon: icon,
        itemCount: maxValue.abs().toString().length,
        minValue: minValue,
        maxValue: maxValue,
        headerMessage: headerMessage,
        onChange: onChange);

@pragma("vm:prefer-inline")
Widget form_grid_2(
        {required int crossAxisCount,
        required double mainAxisSpacing,
        required double crossAxisSpacing,
        double minimumItemWidth = 500,
        required List<Widget> children}) =>
    ResponsiveGridList(
        maxItemsPerRow: crossAxisCount,
        verticalGridSpacing: crossAxisSpacing,
        horizontalGridSpacing: mainAxisSpacing,
        minItemWidth: minimumItemWidth,
        children: children);

@pragma("vm:prefer-inline")
Widget form_label(String text,
        {TextStyle? style,
        required Widget child,
        bool expandLabel = false,
        Widget? icon}) =>
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (icon != null) icon,
                if (icon != null) strut(width: 6),
                if (expandLabel)
                  Expanded(
                      child: Text(text,
                          style: style ??
                              const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis)))
                else
                  Text(text,
                      style: style ??
                          const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis)),
                strut(width: _prompt_label_strut_width),
              ]),
          child
        ]);

@pragma("vm:prefer-inline")
Widget form_label_2(String text,
        {TextStyle? style, required Widget child, Widget? icon}) =>
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            if (icon != null) icon,
            if (icon != null) strut(width: 6),
            Text(text,
                style: style ??
                    const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis)),
            strut(width: _prompt_label_strut_width),
          ]),
          strut(height: 6),
          Row(
            children: <Widget>[
              const SizedBox(
                  width: 10), // fuck strut() its not compile const
              child,
            ],
          )
        ]);

@pragma("vm:prefer-inline")
Widget form_txt(String label, [TextStyle? style]) =>
    Text(label, style: style);

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
Widget form_sec_2(BuildContext context,
        {required Icon headerIcon,
        required Widget title,
        Color? iconColor,
        required Widget child,
        Color? backgroundColor,
        Gradient? gradient}) =>
    Container(
        decoration: BoxDecoration(
            gradient: gradient,
            color: backgroundColor ??
                ThemeProvider.themeOf(context)
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
                  headerIcon,
                  strut(width: 10),
                  title,
                ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                )
              ]),
        ));

@pragma("vm:prefer-inline")
Widget form_sec(BuildContext context,
        {required SectionId header,
        required Widget child,
        Color? backgroundColor,
        Gradient? gradient}) =>
    Container(
        decoration: BoxDecoration(
            gradient: gradient,
            color: backgroundColor ??
                ThemeProvider.themeOf(context)
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
Widget form_switch_1<T>(
        {required void Function(bool res) onChanged,
        bool initialValue = false}) =>
    BasicToggleSwitch(
        onChanged: onChanged, initialValue: initialValue);

@pragma("vm:prefer-inline")
Widget form_seg_btn_1<T>(
        {required List<({T value, String label, Icon? icon})>
            segments,
        required T initialSelection,
        required void Function(T res) onSelect}) =>
    Flexible(
        child: _SegSingleBtn<T>(
      segments: segments,
      onSelect: onSelect,
      initialSelection: initialSelection,
    ));

@pragma("vm:prefer-inline")
Widget form_seg_btn_2<T>(
        {required List<({T value, String label, Icon? icon})>
            segments,
        required Set<T> initialSelection,
        required void Function(List<T> res) onSelect}) =>
    Flexible(
        child: _MSegSingleBtn<T>(
      segments: segments,
      onSelect: onSelect,
      initialSelection: initialSelection,
    ));

class _MSegSingleBtn<T> extends StatefulWidget {
  final List<({T value, String label, Icon? icon})> segments;
  final Set<T> initialSelection;
  final void Function(List<T> res) onSelect;
  final ButtonStyle? style;

  const _MSegSingleBtn(
      {super.key,
      this.style,
      required this.onSelect,
      required this.segments,
      required this.initialSelection});
  @override
  State<_MSegSingleBtn<T>> createState() => _MSegSingleBtnState<T>();
}

class _MSegSingleBtnState<T> extends State<_MSegSingleBtn<T>> {
  late Set<T> _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: <ButtonSegment<T>>[
        for (({T value, String label, Icon? icon}) e
            in widget.segments)
          ButtonSegment<T>(
              value: e.value,
              label: Text(e.label,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis)),
              icon: e.icon)
      ],
      selected: _selection,
      style: widget.style,
      showSelectedIcon: false,
      onSelectionChanged: (Set<T> values) {
        setState(() => _selection = values);
        widget.onSelect.call(values.toList());
      },
    );
  }
}

class _SegSingleBtn<T> extends StatefulWidget {
  final List<({T value, String label, Icon? icon})> segments;
  final T initialSelection;
  final void Function(T res) onSelect;
  final ButtonStyle? style;

  const _SegSingleBtn(
      {super.key,
      this.style,
      required this.onSelect,
      required this.segments,
      required this.initialSelection});

  @override
  State<_SegSingleBtn<T>> createState() => _SegSingleBtnState<T>();
}

class _SegSingleBtnState<T> extends State<_SegSingleBtn<T>> {
  late T _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: <ButtonSegment<T>>[
        for (({T value, String label, Icon? icon}) e
            in widget.segments)
          ButtonSegment<T>(
              value: e.value,
              label: Text(e.label,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis)),
              icon: e.icon)
      ],
      selected: <T>{
        _selection,
      },
      showSelectedIcon: false,
      style: widget.style,
      onSelectionChanged: (Set<T> values) {
        setState(() => _selection = values.first);
        widget.onSelect.call(values.first);
      },
    );
  }
}

@pragma("vm:prefer-inline")
Widget form_col(List<Widget> children,
        {MainAxisAlignment mainAxisAlignment =
            MainAxisAlignment.start,
        MainAxisSize mainAxisSize = MainAxisSize.max,
        CrossAxisAlignment crossAxisAlignment =
            CrossAxisAlignment.center}) =>
    Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: strutAll(children, height: 18));

@pragma("vm:prefer-inline")
Widget form_row(List<Widget> children,
        {MainAxisAlignment mainAxisAlignment =
            MainAxisAlignment.start,
        MainAxisSize mainAxisSize = MainAxisSize.max,
        CrossAxisAlignment crossAxisAlignment =
            CrossAxisAlignment.center}) =>
    Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: strutAll(children, width: 10));

@pragma("vm:prefer-inline")
Widget form_txtin({
  String? hint,
  String? label,
  Icon? prefixIcon,
  Icon? suffixIcon,
  double dim = 100,
  void Function(String)? onChanged,
  TextInputType? inputType,
}) =>
    Flexible(
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
    );
