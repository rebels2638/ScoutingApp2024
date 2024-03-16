import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
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
  const _BetterGridDelegate({required this.dim});

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

const double _prompt_label_strut_width = 8;

class _NumPickBtn extends StatefulWidget {
  final int maxValue;
  final int minValue;
  final int itemCount;
  final void Function(int res) onChange;
  final String label;
  final Icon icon;
  final String headerMessage;
  final int initialData;

  const _NumPickBtn(
      {required this.label,
      required this.icon,
      required this.initialData,
      required this.itemCount,
      required this.minValue,
      required this.maxValue,
      required this.headerMessage,
      required this.onChange});

  @override
  State<_NumPickBtn> createState() => _NumPickBtnState();
}

class _NumPickBtnState extends State<_NumPickBtn> {
  late int _initValue;

  @override
  void initState() {
    super.initState();
    _initValue = widget.initialData;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: UserTelemetry().currentModel.useAltLayout
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: <Widget>[
          if (PreferCompactModal.isCompactPreferred(context))
            IconButton.filled(
                icon: widget.icon,
                onPressed: () => launchNumberPickerDialog(context,
                        maxValue: widget.maxValue.abs(),
                        minValue: widget.minValue.abs(),
                        headerMessage: widget.headerMessage,
                        itemCount: widget.maxValue
                            .abs()
                            .toString()
                            .length, onChange: (int value) {
                      setState(() => _initValue = value);
                      widget.onChange.call(value);
                    }))
          else
            FilledButton(
                child: widget.icon,
                onPressed: () => launchNumberPickerDialog(context,
                        maxValue: widget.maxValue.abs(),
                        minValue: widget.minValue.abs(),
                        headerMessage: widget.headerMessage,
                        itemCount: widget.maxValue
                            .abs()
                            .toString()
                            .length, onChange: (int value) {
                      setState(() => _initValue = value);
                      widget.onChange.call(value);
                    })),
          const SizedBox(width: 6),
          Text.rich(TextSpan(children: <InlineSpan>[
            const TextSpan(text: " = "),
            TextSpan(
                text: _initValue == -1
                    ? "Unset"
                    : _initValue.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold))
          ]))
        ]);
  }
}

class form_numpick extends StatelessWidget {
  final String label;
  final Icon icon;
  final Icon? headerIcon;
  final int initialData;
  final int minValue;
  final int maxValue;
  final bool infiniteLoop;
  final Axis alignment;
  final String headerMessage;
  final String? comment;
  final void Function(int res) onChange;

  const form_numpick(
      {super.key,
      required this.label,
      required this.icon,
      this.headerIcon,
      required this.initialData,
      required this.minValue,
      required this.maxValue,
      this.infiniteLoop = true,
      this.alignment = Axis.vertical,
      required this.headerMessage,
      this.comment,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return _NumPickBtn(
        label: label,
        icon: icon,
        initialData: initialData,
        itemCount: maxValue.abs().toString().length,
        minValue: minValue,
        maxValue: maxValue,
        headerMessage: headerMessage,
        onChange: onChange);
  }
}

class form_grid_2 extends StatelessWidget {
  final ScrollController? scrollController;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double minimumItemWidth;
  final List<Widget> children;

  const form_grid_2(
      {super.key,
      this.scrollController,
      required this.crossAxisCount,
      required this.mainAxisSpacing,
      required this.crossAxisSpacing,
      this.minimumItemWidth = 500,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
        listViewBuilderOptions: ListViewBuilderOptions(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics())),
        maxItemsPerRow: crossAxisCount,
        verticalGridSpacing: crossAxisSpacing,
        horizontalGridSpacing: mainAxisSpacing,
        minItemWidth: minimumItemWidth,
        children: children);
  }
}

class form_label_rigid extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Widget child;
  final bool expandLabel;
  final Widget? icon;

  const form_label_rigid(this.text,
      {super.key,
      required this.child,
      this.style,
      this.expandLabel = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (icon != null) icon!,
                if (icon != null) const SizedBox(width: 6),
                Text(text,
                    style: style ??
                        const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis)),
                const SizedBox(width: _prompt_label_strut_width),
              ]),
          child
        ]);
  }
}

class form_label extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? hint;
  final Widget child;
  final bool expandLabel;
  final Widget? icon;

  const form_label(this.text,
      {super.key,
      required this.child,
      this.style,
      this.hint,
      this.expandLabel = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return UserTelemetry().currentModel.useAltLayout
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                SizedBox(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (hint != null)
                          IconButton(
                              onPressed: () async {},
                              icon: const Icon(
                                  Icons.info_outline_rounded)),
                        Text(
                          text,
                          style: style ??
                              const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                ),
                const SizedBox(height: 6),
                child,
              ])
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (icon != null) icon!,
                      if (icon != null) const SizedBox(width: 6),
                      Text(
                        text,
                        style: style ??
                            const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis),
                      ),
                      if (hint != null) const SizedBox(width: 4),
                      if (hint != null)
                        IconButton(
                            onPressed: () async {},
                            icon: const Icon(
                                Icons.info_outline_rounded)),
                      const SizedBox(
                          width: _prompt_label_strut_width),
                    ]),
                child
              ]);
  }
}

class form_label_2 extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Widget child;
  final Widget? icon;
  final bool allowRigid;

  const form_label_2(this.text,
      {super.key,
      required this.child,
      this.style,
      this.icon,
      this.allowRigid = true});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 6),
            Text(text,
                style: style ??
                    const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis)),
            const SizedBox(width: _prompt_label_strut_width),
          ]),
          const SizedBox(height: 6),
          Row(children: <Widget>[
            if (allowRigid) const SizedBox(width: 10),
            child,
          ])
        ]);
  }
}

class form_grid_1 extends StatelessWidget {
  final int? itemCount;
  final List<Widget> children;
  final double dim;

  const form_grid_1(
      {super.key,
      this.itemCount,
      required this.children,
      this.dim = 240});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: _BetterGridDelegate(dim: dim),
        itemCount: itemCount ?? children.length,
        itemBuilder: (BuildContext context, int index) =>
            GridTile(child: children[index]));
  }
}

class form_grid_sec extends StatelessWidget {
  final SectionId header;
  final Gradient? gradient;
  final Widget child;

  const form_grid_sec(
      {super.key,
      required this.header,
      this.gradient,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            gradient: gradient,
            color: ThemeProvider.themeOf(context)
                .data
                .navigationBarTheme
                .surfaceTintColor),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment:
                  UserTelemetry().currentModel.useAltLayout
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment:
                        UserTelemetry().currentModel.useAltLayout
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(header.icon, size: 36),
                      const SizedBox(width: 10),
                      Text(header.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                    ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                )
              ]),
        ));
  }
}

class form_sec_rigid extends StatelessWidget {
  final Gradient? gradient;
  final Widget child;
  final Color? iconColor;
  final Widget title;
  final Icon headerIcon;

  const form_sec_rigid(
      {super.key,
      required this.headerIcon,
      required this.title,
      this.iconColor,
      required this.child,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: gradient,
            color: ThemeProvider.themeOf(context)
                .data
                .navigationBarTheme
                .surfaceTintColor,
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  headerIcon,
                  const SizedBox(width: 10),
                  title,
                ]),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: child,
            )
          ]),
        ));
  }
}

class form_sec_2 extends StatelessWidget {
  final Gradient? gradient;
  final Widget child;
  final Color? iconColor;
  final Widget title;
  final Icon headerIcon;

  const form_sec_2(
      {super.key,
      required this.headerIcon,
      required this.title,
      this.iconColor,
      required this.child,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: gradient,
            color: ThemeProvider.themeOf(context)
                .data
                .secondaryHeaderColor,
            borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment:
                  UserTelemetry().currentModel.useAltLayout
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment:
                        UserTelemetry().currentModel.useAltLayout
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                    children: <Widget>[
                      headerIcon,
                      const SizedBox(width: 10),
                      title,
                    ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                )
              ]),
        ));
  }
}

class form_sec extends StatelessWidget {
  final SectionId header;
  final Widget child;
  final Color? backgroundColor;

  const form_sec(
      {super.key,
      required this.header,
      required this.child,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(header.icon, size: 36),
                  const SizedBox(width: 10),
                  Text(header.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))
                ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                )
              ]),
        ));
  }
}

class MSegSingleBtn<T> extends StatefulWidget {
  final List<({T value, String label, Icon? icon})> segments;
  final Set<T> initialSelection;
  final void Function(List<T> res) onSelect;
  final ButtonStyle? style;

  const MSegSingleBtn(
      {super.key,
      this.style,
      required this.onSelect,
      required this.segments,
      required this.initialSelection});
  @override
  State<MSegSingleBtn<T>> createState() => MSegSingleBtnState<T>();
}

class MSegSingleBtnState<T> extends State<MSegSingleBtn<T>> {
  late Set<T> _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection;
    Debug().info(
        "MSegButton$hashCode has initial selection $_selection");
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
      multiSelectionEnabled: true,
      onSelectionChanged: (Set<T> values) {
        setState(() => _selection = values);
        widget.onSelect.call(values.toList());
      },
    );
  }
}

class SegSingleBtn<T> extends StatefulWidget {
  final List<({T value, String label, Icon? icon})> segments;
  final T initialSelection;
  final void Function(T res) onSelect;
  final ButtonStyle? style;

  const SegSingleBtn(
      {super.key,
      this.style,
      required this.onSelect,
      required this.segments,
      required this.initialSelection});

  @override
  State<SegSingleBtn<T>> createState() => SegSingleBtnState<T>();
}

class SegSingleBtnState<T> extends State<SegSingleBtn<T>> {
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

class form_col extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const form_col(
    this.children, {
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: strutAll(children, height: 18));
  }
}

class form_row extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const form_row(
      {super.key,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.max,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: strutAll(children, width: 10));
  }
}

class form_txtin extends StatelessWidget {
  final String? hint;
  final String? label;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final void Function(String)? onChanged;
  final TextInputType? inputType;

  const form_txtin(
      {super.key,
      this.hint,
      this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.inputType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        onChanged: (String e) => onChanged?.call(e),
        keyboardType: inputType,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: prefixIcon,
          suffix: suffixIcon,
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(gapPadding: 0),
        ),
      ),
    );
  }
}
