import 'package:flutter/material.dart';
import 'package:proto1/samples/soma_sample.dart';

import '../../misc/maths.dart';
import '../../model/appstate.dart';
import '../../model/config_model.dart';
import '../border_clip_path.dart';

class SomaPspGraphWidget extends StatefulWidget {
  final double height;
  final Color bgColor;
  final AppState appState;
  final SampleData sampleData;

  const SomaPspGraphWidget(
    this.appState, {
    super.key,
    required this.height,
    required this.bgColor,
    required this.sampleData,
  });

  @override
  State<SomaPspGraphWidget> createState() => _SomaPspGraphWidgetState();
}

class _SomaPspGraphWidgetState extends State<SomaPspGraphWidget> {
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
  late Paint zeroLinePaint;
  late Paint thresholdLinePaint;

  DataPainter(this.samples, this.appState) {
    cm = appState.configModel;

    linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    zeroLinePaint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    thresholdLinePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;
  }

  @override
  // Size is the physical size. <0,0> is top-left.
  // We use the Maths' functions to map data to unit-space
  // which then allows to map to graph-space.
  void paint(Canvas canvas, Size size) {
    _drawHorizontalLines(canvas, size, appState);
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
      sY = somaSamples[t].psp; // Soma PSP

      // The sample value needs to be mapped
      double uX = Maths.mapSampleToUnit(
        t.toDouble(),
        cm.rangeStart.toDouble(),
        cm.rangeEnd.toDouble(),
      );
      double wX = Maths.mapUnitToWindow(uX, 0.0, size.width);

      double uY = Maths.mapSampleToUnit(
        sY,
        samples.samples.somaPspMin,
        samples.samples.somaPspMax,
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

  void _drawHorizontalLines(
    Canvas canvas,
    Size size,
    AppState appState,
  ) {
    List<SomaSample> somaSamples = appState.samplesData.samples.somaSamples;

    if (somaSamples.isEmpty) return;

    // ----------------------------------------------------------------
    // Zero line
    // ----------------------------------------------------------------
    _drawHorizontalLine(
      0.0,
      samples.samples.somaPspMin,
      samples.samples.somaPspMax,
      canvas,
      zeroLinePaint,
      size,
    );

    // ----------------------------------------------------------------
    // Threshold line
    // ----------------------------------------------------------------
    _drawHorizontalLine(
      appState.model.neuron.threshold,
      samples.samples.somaPspMin,
      samples.samples.somaPspMax,
      canvas,
      thresholdLinePaint,
      size,
    );
  }

  void _drawHorizontalLine(
      double y, double min, double max, Canvas canvas, Paint paint, Size size) {
    double uY = Maths.mapSampleToUnit(y, min, max);

    double bottom = size.height;
    double right = size.width;

    // graph space has +Y downward, but the data is oriented as +Y upward
    // so we flip in unit-space.
    uY = 1.0 - uY;
    double wY = Maths.mapUnitToWindow(uY, 0.0, bottom);

    var (_, lY) = Maths.mapWindowToLocal(0.0, wY, 0.0, 0.0);

    double wBx = Maths.mapUnitToWindow(0.0, 0.0, right);
    double wEx = Maths.mapUnitToWindow(1.0, 0.0, right);

    var (lBx, _) = Maths.mapWindowToLocal(wBx, 0.0, 0.0, 0.0);
    var (lEx, _) = Maths.mapWindowToLocal(wEx, 0.0, 0.0, 0.0);

    canvas.drawLine(Offset(lBx, lY), Offset(lEx, lY), paint);
  }
}
