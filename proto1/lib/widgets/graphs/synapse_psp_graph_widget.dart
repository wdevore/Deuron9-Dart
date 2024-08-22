import 'package:flutter/material.dart';

import '../../misc/maths.dart';
import '../../model/appstate.dart';
import '../../model/config_model.dart';
import '../../samples/synapse_samples.dart';
import '../border_clip_path.dart';

class PspGraphWidget extends StatefulWidget {
  final double height;
  final Color bgColor;
  final AppState appState;
  final SampleData sampleData;

  const PspGraphWidget(
    this.appState, {
    super.key,
    required this.height,
    required this.bgColor,
    required this.sampleData,
  });

  @override
  State<PspGraphWidget> createState() => _PspGraphWidgetState();
}

class _PspGraphWidgetState extends State<PspGraphWidget> {
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
    // Iterate the data and map samples that are within range-start
    // range-end. The data width should match width of the Input sample
    // data because the noise is "mixed in" with the input samples.

    List<List<SynapseSamples>?> synSamples = samples.samples.synSamples;

    double bottom = size.height.toDouble();
    double sY = 0.0;
    double plY = bottom; // previously mapped y value
    double plX = 0.0; // previously mapped x value

    List<SynapseSamples>? activeSamples =
        synSamples[appState.model.activeSynapse];

    for (var t = cm.rangeStart; t < cm.rangeEnd; t++) {
      if (activeSamples != null) {
        if (activeSamples.isNotEmpty) {
          sY = activeSamples[t].psp;

          // The sample value needs to be mapped
          double uX = Maths.mapSampleToUnit(
              t.toDouble(), cm.rangeStart.toDouble(), cm.rangeEnd.toDouble());
          double uY = Maths.mapSampleToUnit(sY, samples.samples.synapseSurgeMin,
              samples.samples.synapseSurgeMax);

          double wX = Maths.mapUnitToWindow(uX, 0.0, size.width);

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
  }
}
