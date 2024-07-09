import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';

class BreathingIndicator extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? glowColor;

  const BreathingIndicator({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.glowColor,
  });

  @override
  BreathingIndicatorState createState() => BreathingIndicatorState();
}

class BreathingIndicatorState extends State<BreathingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    animation.removeListener(() {});
    super.dispose();
  }

  /// Core animation control is done here.
  /// Animation completes in 2 seconds then repeat by reversing.
  void initAnimation() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animationController.repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 5.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  double get width => widget.width ?? 10;
  double get height => widget.height ?? 10;
  Color get backgroundColor =>
      widget.backgroundColor ?? ColorConstants.primaryColor;
  Color get glowColor =>
      widget.glowColor ?? ColorConstants.primaryColor.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 0.5,
            spreadRadius: animation.value,
          ),
        ],
      ),
    );
  }
}
