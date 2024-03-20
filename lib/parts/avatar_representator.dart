import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/descriptors/gradient_descriptor.dart';

class AvatarRepresentator extends StatefulWidget {
  const AvatarRepresentator({
    super.key,
  });

  @override
  State<AvatarRepresentator> createState() =>
      _AvatarRepresentatorState();
}

class _AvatarRepresentatorState extends State<AvatarRepresentator> {
  late LinearGradientDescriptor _descriptor;

  @override
  void initState() {
    super.initState();
    _descriptor = LinearGradientDescriptor.random();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(
          () => _descriptor = LinearGradientDescriptor.random()),
      child: SizedBox(
        width: 124,
        height: 124,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                gradient: _descriptor.gr)),
      ),
    );
  }
}
