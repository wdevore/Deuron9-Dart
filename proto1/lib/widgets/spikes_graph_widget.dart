import 'dart:ui';

import 'package:flutter/material.dart';

import 'border_clip_path.dart';

class SpikesGraphWidget extends StatefulWidget {
  const SpikesGraphWidget(
      {super.key,
      required this.height,
      required this.bgColor,
      required this.points});

  final double height;
  final Color bgColor;
  final List<Offset> points;

  @override
  State<SpikesGraphWidget> createState() => _SpikesGraphWidgetState();
}

class _SpikesGraphWidgetState extends State<SpikesGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BorderClipPath(),
      child: Container(
        width: double.maxFinite,
        height: widget.height,
        color: widget.bgColor,
        child: CustomPaint(
          painter: SpikePainter(widget.points),
        ),
      ),
    );
  }
}

class SpikePainter extends CustomPainter {
  final List<Offset> points;

  SpikePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = PointMode.points;
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
