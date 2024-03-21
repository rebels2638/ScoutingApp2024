import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:theme_provider/theme_provider.dart';

class PlusMinus extends StatefulWidget {
  final int initialValue;
  final void Function(int)?
      onValueChanged; // callback to return value

  const PlusMinus(
      {super.key, this.initialValue = 0, this.onValueChanged});

  @override
  State<PlusMinus> createState() => _PlusMinusState();
}

class _PlusMinusState extends State<PlusMinus>
    with AutomaticKeepAliveClientMixin {
  late int _val;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: strutAll(<Widget>[
        if (_val > 0)
          Tooltip(
            message: "Reset value to 0",
            child: IconButton.filledTonal(
              onPressed: () {
                setState(() => _val = 0);
                widget.onValueChanged?.call(_val);
              },
              icon: const Icon(Icons.exposure_zero_rounded),
            ),
          ),
        Tooltip(
          message: "Decrement value by 1",
          child: IconButton.filledTonal(
            onPressed: () {
              int newVal = _val - 1;
              if (newVal >= 0) {
                setState(() => _val = newVal);
                widget.onValueChanged?.call(_val);
              }
            },
            icon: Icon(Icons.remove_rounded,
                color: _val == 0
                    ? ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .primary
                        .grayScale()
                    : ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .primary),
          ),
        ),
        Text(_val.toString(), style: const TextStyle(fontSize: 20)),
        Tooltip(
          message: "Increment value by 1",
          child: IconButton.filledTonal(
            onPressed: () {
              int newVal = _val + 1;
              if (newVal <= 99) {
                setState(() => _val = newVal);
                widget.onValueChanged?.call(_val);
              }
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ),
      ], width: 6),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PlusMinusRating extends StatefulWidget {
  final int initialValue;
  final void Function(int)?
      onValueChanged; // callback to return value

  const PlusMinusRating(
      {super.key, this.initialValue = 0, this.onValueChanged});

  @override
  // ignore: library_private_types_in_public_api
  _PlusMinusRatingState createState() => _PlusMinusRatingState();
}

class _PlusMinusRatingState extends State<PlusMinusRating>
    with AutomaticKeepAliveClientMixin {
  late int _val;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: strutAll(<Widget>[
        if (_val > 0)
          Tooltip(
            message: "Reset value to 0",
            child: IconButton.filledTonal(
              onPressed: () {
                setState(() => _val = 0);
                widget.onValueChanged?.call(_val);
              },
              icon: const Icon(Icons.exposure_zero_rounded),
            ),
          ),
        Tooltip(
          message: "Decrement value by 1",
          child: IconButton.filledTonal(
            onPressed: () {
              int newVal = _val - 1;
              if (newVal >= 0) {
                setState(() => _val = newVal);
                widget.onValueChanged?.call(_val);
              }
            },
            icon: Icon(Icons.remove_rounded,
                color: _val == 0
                    ? ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .primary
                        .grayScale()
                    : ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .primary),
          ),
        ),
        Text(_val.toString(), style: const TextStyle(fontSize: 20)),
        Tooltip(
          message: "Increment value by 1",
          child: IconButton.filledTonal(
              onPressed: () {
                int newVal = _val + 1;
                if (newVal <= 10) {
                  setState(() => _val = newVal);
                  widget.onValueChanged?.call(_val);
                }
              },
              icon: const Icon(Icons.add_rounded)),
        ),
      ], width: 6),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
