import 'package:flutter/material.dart';

import '../../misc/maths.dart';
import '../../model/appstate.dart';
import '../../model/config_model.dart';
import '../../samples/synapse_samples.dart';
import '../border_clip_path.dart';

class SynapseWeightsGraphWidget extends StatefulWidget {
  final double height;
  final Color bgColor;
  final AppState appState;
  final SampleData sampleData;

  const SynapseWeightsGraphWidget(
    this.appState, {
    super.key,
    required this.height,
    required this.bgColor,
    required this.sampleData,
  });

  @override
  State<SynapseWeightsGraphWidget> createState() =>
      _SynapseWeightsGraphWidgetState();
}

class _SynapseWeightsGraphWidgetState extends State<SynapseWeightsGraphWidget> {
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
  late Paint initialLinePaint;

  DataPainter(this.samples, this.appState) {
    cm = appState.configModel;

    linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    zeroLinePaint = Paint()
      ..color = Colors.green.shade900
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    initialLinePaint = Paint()
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
    // Iterate the data and map samples that are within range-start
    // range-end. The data width should match width of the Input sample
    // data because the noise is "mixed in" with the input samples.

    List<List<SynapseSamples>?> synSamples = samples.samples.synSamples;

    double bottom = size.height;
    double sY = 0.0;
    double plY = bottom; // previously mapped y value
    double plX = 0.0; // previously mapped x value

    List<SynapseSamples>? activeSamples =
        synSamples[appState.model.activeSynapse];

    if (activeSamples != null && activeSamples.isEmpty) return;

    for (var t = cm.rangeStart; t < cm.rangeEnd; t++) {
      sY = activeSamples![t].weight;

      // The sample value needs to be mapped
      double uX = Maths.mapSampleToUnit(
        t.toDouble(),
        cm.rangeStart.toDouble(),
        cm.rangeEnd.toDouble(),
      );
      double wX = Maths.mapUnitToWindow(uX, 0.0, size.width);

      double uY = Maths.mapSampleToUnit(
        sY,
        samples.samples.synapseWeightMin,
        samples.samples.synapseWeightMax,
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
    List<List<SynapseSamples>?> synSamples = samples.samples.synSamples;

    List<SynapseSamples>? activeSamples =
        synSamples[appState.model.activeSynapse];

    if (activeSamples != null && activeSamples.isEmpty) return;

    // ----------------------------------------------------------------
    // Zero line
    // ----------------------------------------------------------------
    _drawHorizontalLine(
      0.0,
      samples.samples.synapseWeightMin,
      samples.samples.synapseWeightMax,
      canvas,
      zeroLinePaint,
      size,
    );

    // ----------------------------------------------------------------
    // Initial weight line
    // ----------------------------------------------------------------
    _drawHorizontalLine(
      appState.environment.synapses[appState.model.activeSynapse].initialW,
      samples.samples.synapseWeightMin,
      samples.samples.synapseWeightMax,
      canvas,
      initialLinePaint,
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
