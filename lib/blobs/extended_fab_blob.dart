import 'dart:math';

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ExpFabBlob extends StatefulWidget {
  final bool? initialOpen;
  final double distance;
  final Widget closeWidget;
  final Widget defaultWidget;
  final List<Widget> children;

  const ExpFabBlob({
    super.key,
    this.initialOpen,
    this.closeWidget = const Icon(Icons.close_rounded),
    required this.defaultWidget,
    required this.distance,
    required this.children,
  });

  @override
  State<ExpFabBlob> createState() => _ExpFabBlobState();
}

class _ExpFabBlobState extends State<ExpFabBlob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: <Widget>[
          SizedBox(
            width: 64,
            height: 64,
            child: Center(
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                child: InkWell(
                  onTap: () => setState(() {
                    _open = !_open;
                    _open
                        ? _controller.forward()
                        : _controller.reverse();
                  }),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: widget.closeWidget),
                ),
              ),
            ),
          ),
          ..._buildExpandingActionButtons(),
          IgnorePointer(
            ignoring: _open,
            child: AnimatedContainer(
              transformAlignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                _open ? 0.7 : 1.0,
                _open ? 0.7 : 1.0,
                1.0,
              ),
              duration: const Duration(milliseconds: 250),
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
              child: AnimatedOpacity(
                opacity: _open ? 0.0 : 1.0,
                curve: const Interval(0.25, 1.0,
                    curve: Curves.easeInOut),
                duration: const Duration(milliseconds: 250),
                child: FloatingActionButton(
                  onPressed: () => setState(() {
                    _open = !_open;
                    _open
                        ? _controller.forward()
                        : _controller.reverse();
                  }),
                  child: widget.defaultWidget,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final List<Widget> children = <Widget>[];
    final int count = widget.children.length;
    final double step = 90 / (count - 1);
    for (int i = 0, angleInDegrees = 0;
        i < count;
        i++, angleInDegrees += step.toInt()) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees.toDouble(),
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (BuildContext context, Widget? child) {
        final Offset offset = Offset.fromDirection(
          directionInDegrees * (pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeProvider.themeOf(context).data;
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      color: theme.floatingActionButtonTheme.backgroundColor,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
