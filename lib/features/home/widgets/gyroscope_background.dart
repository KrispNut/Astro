import 'package:astro/core/theme/AppColors.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GyroscopeBackground extends StatefulWidget {
  final Widget Function(BuildContext context, double x, double y) builder;
  final double sensitivity;

  const GyroscopeBackground({
    Key? key,
    required this.builder,
    this.sensitivity = 0.02,
  }) : super(key: key);

  @override
  _GyroscopeBackgroundState createState() => _GyroscopeBackgroundState();
}

class _GyroscopeBackgroundState extends State<GyroscopeBackground> {
  double x = 0;
  double y = 0;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        x = (x + event.y * widget.sensitivity) * 0.9;
        y = (y + event.x * widget.sensitivity) * 0.9;
      });
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.1 + x * 0.08, 0.1 + y * 0.08),
          radius: 1.3,
          colors: [
            AppColors.primaryColor.withOpacity(0.25), // Updated
            AppColors.primaryColor.withOpacity(0.1), // Updated
            AppColors.bgColor, // Updated
          ],
          stops: const [0.0, 0.3, 0.7],
        ),
      ),
      child: Transform(
        transform:
            Matrix4.identity()
              ..rotateX(x * 0.015)
              ..rotateY(y * 0.015)
              ..translate(x * 8, y * 8),
        alignment: FractionalOffset.center,
        child: widget.builder(context, x, y),
      ),
    );
  }
}
