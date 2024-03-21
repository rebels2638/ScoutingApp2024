import 'package:flutter/material.dart';

class SpecialButton extends StatefulWidget {
  final Widget label;
  final Widget icon;
  final List<Color> colors;
  final Alignment beginAlign;
  final Alignment endAlign;
  final Alignment antiBeginAlign;
  final Alignment antiEndAlign;
  final List<Color> antiColors;
  final Color shadow;
  final Color antiShadow;
  final bool shrinkwrap;
  final void Function() onPressed;
  final bool keepState;

  const SpecialButton(
      {super.key,
      required this.beginAlign,
      required this.endAlign,
      required this.antiBeginAlign,
      required this.antiEndAlign,
      required this.label,
      required this.icon,
      this.keepState = true,
      required this.shadow,
      this.shrinkwrap = true,
      required this.antiShadow,
      required this.antiColors,
      required this.onPressed,
      required this.colors});

  factory SpecialButton.premade1(
          {required String label,
          required Widget icon,
          required void Function() onPressed,
          bool shrinkWrap = true}) =>
      SpecialButton(
          beginAlign: Alignment.topLeft,
          endAlign: Alignment.bottomRight,
          antiBeginAlign: Alignment.topRight,
          antiEndAlign: Alignment.bottomLeft,
          shrinkwrap: shrinkWrap,
          label: Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF))),
          icon: icon,
          shadow: const Color.fromARGB(132, 65, 170, 107),
          antiShadow: const Color.fromARGB(190, 240, 53, 29),
          antiColors: const <Color>[
            Color.fromARGB(255, 216, 148, 53),
            Color.fromARGB(255, 209, 24, 24)
          ],
          onPressed: onPressed,
          colors: const <Color>[
            Color.fromARGB(255, 55, 125, 66),
            Color.fromARGB(255, 22, 102, 83)
          ]);

  factory SpecialButton.premade2(
          {required String label,
          required Widget icon,
          required void Function() onPressed,
          bool shrinkWrap = true}) =>
      SpecialButton(
          beginAlign: Alignment.topLeft,
          endAlign: Alignment.bottomRight,
          antiBeginAlign: Alignment.topRight,
          antiEndAlign: Alignment.bottomLeft,
          shrinkwrap: shrinkWrap,
          label: Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF))),
          icon: icon,
          shadow: const Color.fromARGB(132, 65, 93, 170),
          antiShadow: const Color.fromARGB(189, 240, 29, 120),
          antiColors: const <Color>[
            Color.fromARGB(255, 216, 53, 178),
            Color.fromARGB(255, 206, 54, 110)
          ],
          onPressed: onPressed,
          colors: const <Color>[
            Color.fromARGB(255, 49, 95, 174),
            Color.fromARGB(255, 81, 92, 162)
          ]);

  factory SpecialButton.premade3(
          {required String label,
          required Widget icon,
          required void Function() onPressed,
          bool shrinkWrap = true}) =>
      SpecialButton(
          beginAlign: Alignment.topLeft,
          endAlign: Alignment.bottomRight,
          antiBeginAlign: Alignment.topRight,
          antiEndAlign: Alignment.bottomLeft,
          shrinkwrap: shrinkWrap,
          label: Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF))),
          icon: icon,
          shadow: const Color.fromARGB(166, 238, 40, 185),
          antiShadow: const Color.fromARGB(189, 29, 240, 131),
          antiColors: const <Color>[
            Color.fromARGB(255, 75, 216, 53),
            Color.fromARGB(255, 54, 206, 130)
          ],
          onPressed: onPressed,
          colors: const <Color>[
            Color.fromARGB(255, 216, 53, 178),
            Color.fromARGB(255, 206, 54, 110)
          ]);

  factory SpecialButton.premade4(
          {required String label,
          required Widget icon,
          required void Function() onPressed,
          bool shrinkWrap = true}) =>
      SpecialButton(
          beginAlign: Alignment.topRight,
          endAlign: Alignment.bottomLeft,
          antiBeginAlign: Alignment.topLeft,
          antiEndAlign: Alignment.bottomRight,
          shrinkwrap: shrinkWrap,
          label: Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF))),
          icon: icon,
          shadow: const Color.fromARGB(166, 255, 193, 7),
          antiShadow: const Color.fromARGB(188, 205, 135, 102),
          antiColors: const <Color>[
            Color.fromARGB(255, 255, 140, 0),
            Color.fromARGB(255, 255, 204, 0)
          ],
          onPressed: onPressed,
          colors: const <Color>[
            Color.fromARGB(255, 230, 81, 0),
            Color.fromARGB(255, 186, 128, 0)
          ]);

  factory SpecialButton.premade5(
          {required String label,
          required Widget icon,
          required void Function() onPressed,
          bool shrinkWrap = true}) =>
      SpecialButton(
          beginAlign: Alignment.topRight,
          endAlign: Alignment.bottomLeft,
          antiBeginAlign: Alignment.topLeft,
          antiEndAlign: Alignment.bottomRight,
          shrinkwrap: shrinkWrap,
          label: Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF))),
          icon: icon,
          shadow: const Color.fromARGB(166, 7, 255, 94),
          antiShadow: const Color.fromARGB(188, 205, 102, 102),
          antiColors: const <Color>[
            Color.fromARGB(255, 255, 0, 0),
            Color.fromARGB(255, 255, 102, 102)
          ],
          onPressed: onPressed,
          colors: const <Color>[
            Color.fromARGB(255, 0, 230, 107),
            Color.fromARGB(255, 28, 186, 0)
          ]);

  factory SpecialButton.premade6(
          {required String label,
          required Widget icon,
          required void Function() onPressed,
          bool shrinkWrap = true}) =>
      SpecialButton(
          beginAlign: Alignment.topRight,
          endAlign: Alignment.bottomLeft,
          antiBeginAlign: Alignment.topLeft,
          antiEndAlign: Alignment.bottomRight,
          shrinkwrap: shrinkWrap,
          label: Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF))),
          icon: icon,
          shadow: const Color.fromARGB(166, 7, 7, 255),
          antiShadow: const Color.fromARGB(187, 102, 205, 186),
          antiColors: const <Color>[
            Color.fromARGB(255, 0, 255, 162),
            Color.fromARGB(255, 102, 255, 237)
          ],
          onPressed: onPressed,
          colors: const <Color>[
            Color.fromARGB(255, 0, 0, 230),
            Color.fromARGB(255, 0, 0, 186)
          ]);

  @override
  State<SpecialButton> createState() => _SpecialButtonState();
}

class _SpecialButtonState extends State<SpecialButton>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _shadowController;
  late final Animation<Offset> _shadowTween;

  late bool isTappedDown;
  late bool isTappedOver;

  @override
  void initState() {
    super.initState();
    isTappedDown = false;
    isTappedOver = false;
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _shadowTween = Tween<Offset>(
            begin: const Offset(-4, -4), end: const Offset(4, 4))
        .animate(CurvedAnimation(
            parent: _shadowController, curve: Curves.easeInOut))
      ..addListener(() => setState(() {}));
    _shadowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shadowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget base = AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color:
                    !isTappedDown ? widget.shadow : widget.antiShadow,
                offset: _shadowTween.value,
                blurRadius: 10)
          ],
          gradient: !isTappedDown
              ? LinearGradient(
                  begin: widget.beginAlign,
                  end: widget.endAlign,
                  colors: widget.colors)
              : LinearGradient(
                  begin: widget.antiBeginAlign,
                  end: widget.antiEndAlign,
                  colors: widget.antiColors),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          widget.icon,
          const SizedBox(width: 6),
          widget.label,
        ],
      ),
    );
    return GestureDetector(
      onTapDown: (_) => setState(() => isTappedDown =
          !isTappedDown), // for asethetics shit, idk how to spell the word :P
      onTap: () => widget.onPressed.call(),
      child: widget.shrinkwrap ? FittedBox(child: base) : base,
    );
  }

  @override
  bool get wantKeepAlive => widget.keepState;
}
