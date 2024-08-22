import 'package:flutter/material.dart';
import 'package:proto1/samples/soma_sample.dart';

import '../../misc/maths.dart';
import '../../model/appstate.dart';
import '../../model/config_model.dart';
import '../border_clip_path.dart';

class SomaAPFastGraphWidget extends StatefulWidget {
  final double height;
  final Color bgColor;
  final AppState appState;
  final SampleData sampleData;

  const SomaAPFastGraphWidget(
    this.appState, {
    super.key,
    required this.height,
    required this.bgColor,
    required this.sampleData,
  });

  @override
  State<SomaAPFastGraphWidget> createState() => _SomaAPFastGraphWidgetState();
}

class _SomaAPFastGraphWidgetState extends State<SomaAPFastGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BorderClipPath(),
      child: Container(
        width: double.maxFinite,
        height: widget.height,
        color: widget.bgColor,
        child: CustomPaint(
          painter: DataPainter(widget.sampleData, widget.appState),
        ),
      ),
    );
  }
}

class DataPainter extends CustomPainter {
  final AppState appState;
  final SampleData samples;

  late ConfigModel cm;

  final strokeWidth = 1.0;

  late Paint linePaint;

  DataPainter(this.samples, this.appState) {
    cm = appState.configModel;

    linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;
  }

  @override
  // Size is the physical size. <0,0> is top-left.
  // We use the Maths' functions to map data to unit-space
  // which then allows to map to graph-space.
  void paint(Canvas canvas, Size size) {
    _draw(canvas, size, strokeWidth, appState);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _draw(Canvas canvas, Size size, double strokeWidth, AppState appState) {
    List<SomaSample> somaSamples = appState.samplesData.samples.somaSamples;

    double bottom = size.height;
    double sY = 0.0;
    double plY = bottom; // previously mapped y value
    double plX = 0.0; // previously mapped x value

    if (somaSamples.isEmpty) return;

    for (var t = cm.rangeStart; t < cm.rangeEnd; t++) {
      sY = somaSamples[t].apFast;

      // The sample value needs to be mapped
      double uX = Maths.mapSampleToUnit(
        t.toDouble(),
        cm.rangeStart.toDouble(),
        cm.rangeEnd.toDouble(),
      );
      double wX = Maths.mapUnitToWindow(uX, 0.0, size.width);

      double uY = Maths.mapSampleToUnit(
        sY,
        samples.samples.somaAPFastMin,
        samples.samples.somaAPFastMax,
      );

      // graph space has +Y downward, but the data is oriented as +Y upward
      // so we flip in unit-space.
      uY = 1.0 - uY;
      double wY = Maths.mapUnitToWindow(uY, 0.0, bottom);

      var (lX, lY) = Maths.mapWindowToLocal(wX, wY, 0.0, 0.0);

      canvas.drawLine(Offset(plX, plY), Offset(lX, lY), linePaint);
      plX = lX;
      plY = lY;
    }
  }
}
