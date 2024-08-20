import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/environment.dart';
import '../../misc/maths.dart';
import '../../model/appstate.dart';
import '../../model/config_model.dart';
import '../../samples/samples.dart';
import '../../samples/synapse_samples.dart';
import '../border_clip_path.dart';

// This graph renders chains of Spikes: Noise, Stimulus and
// Soma spikes.
// Each spike is a either a dot or vertical lines about N pixels in height
// Each row is seperated by ~2px.
// Poisson spikes are orange, AP spikes are green.
// Poisson is drawn first then AP.
//
// Graph is shaped like this:
//      .----------------> +X
//  1   :  |   ||     |   | |       ||     |
//  2   :    |   |   ||     ||     |    |        <-- a row ~2px height
//  3   :   |    |    |         | |   |     |
//      v
//      +Y
//
// Only the X-axis is mapped Y is simply a height in graph-space.
//
// This graph also shows the Neuron's Post spike (i.e. the output of the neuron)

class SpikesGraphWidget extends StatefulWidget {
  final double height;
  final Color bgColor;
  final AppState appState;
  final SampleData sampleData;

  const SpikesGraphWidget(
    this.appState, {
    super.key,
    required this.height,
    required this.bgColor,
    required this.sampleData,
  });

  @override
  State<SpikesGraphWidget> createState() => _SpikesGraphWidgetState();
}

class _SpikesGraphWidgetState extends State<SpikesGraphWidget> {
  @override
  Widget build(BuildContext context) {
    // final samples = context.watch<SampleData>();
    return ClipPath(
      clipper: BorderClipPath(),
      child: Container(
        width: double.maxFinite,
        height: widget.height,
        color: widget.bgColor,
        child: CustomPaint(
          painter: SpikePainter(widget.sampleData, widget.appState),
        ),
      ),
    );
  }
}

class SpikePainter extends CustomPainter {
  // final ConfigModel cm;
  // final Environment environment;
  final AppState appState;
  final SampleData samples;
  // Mapped points
  List<Offset> points = [];

  late ConfigModel cm;
  late Environment env;

  final strokeWidth = 4.0;
  final spikeRowOffset = 8;

  SpikePainter(this.samples, this.appState) {
    cm = appState.configModel;
    env = appState.environment;
  }

  @override
  // Size is the physical size. <0,0> is top-left.
  // We use the Maths' functions to map data to unit-space
  // which then allows to map to graph-space.
  void paint(Canvas canvas, Size size) {
    _drawNoise(canvas, size, strokeWidth, spikeRowOffset);
    _drawStimulus(canvas, size, strokeWidth, spikeRowOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawNoise(
      Canvas canvas, Size size, double strokeWidth, int spikeRowOffset) {
    final paint = Paint()
      ..color = Colors.yellow.shade600
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    points.clear();

    double wY = 0.0;

    // Iterate the noise data and map samples that are within range-start
    // range-end. The data width should match width of the Input sample
    // data because the noise is "mixed in" with the input samples.

    // How many synapses (aka channels) do we have.
    // int channelCnt = environment.synapses.length;

    // Channels 0-9 are stimulus, 10-19 are noise
    int channel = 0;
    List<List<SynapseSamples>?> synSamples = samples.samples.synSamples;

    for (var synapse in synSamples) {
      if (synapse != null) {
        if (synapse.isNotEmpty) {
          if (channel > 9) {
            for (var t = cm.rangeStart; t < cm.rangeEnd; t++) {
              if (synapse[t].input == 1) {
                // Spiked?
                // The sample value needs to be mapped
                double uX = Maths.mapSampleToUnit(t.toDouble(),
                    cm.rangeStart.toDouble(), cm.rangeEnd.toDouble());
                double wX = Maths.mapUnitToWindow(uX, 0.0, size.width);
                TupleDouble lXY = Maths.mapWindowToLocal(wX, wY, 0.0, 2.0);
                points.add(Offset(lXY.a, lXY.b));
              }
            }
            // Update row/y value and offset by a few pixels
            wY += spikeRowOffset;
          }
        }
      }
      channel++;
    }

    // Now plot all mapped points.
    canvas.drawPoints(PointMode.points, points, paint);
  }

  void _drawStimulus(
      Canvas canvas, Size size, double strokeWidth, int spikeRowOffset) {
    final paint = Paint()
      ..color = Colors.green.shade600
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    points.clear();

    double wY = 80.0;

    // Iterate the noise data and map samples that are within range-start
    // range-end. The data width should match width of the Input sample
    // data because the noise is "mixed in" with the input samples.

    // How many synapses (aka channels) do we have.
    // int channelCnt = environment.synapses.length;

    // Channels 0-9 are stimulus, 10-19 are noise
    int channel = 0;
    List<List<SynapseSamples>?> synSamples = samples.samples.synSamples;

    for (var synapse in synSamples) {
      if (synapse != null) {
        if (synapse.isNotEmpty) {
          if (channel < 10) {
            for (var t = cm.rangeStart; t < cm.rangeEnd; t++) {
              if (synapse[t].input == 1) {
                // Spiked?
                // The sample value needs to be mapped
                double uX = Maths.mapSampleToUnit(t.toDouble(),
                    cm.rangeStart.toDouble(), cm.rangeEnd.toDouble());
                double wX = Maths.mapUnitToWindow(uX, 0.0, size.width);
                TupleDouble lXY = Maths.mapWindowToLocal(wX, wY, 0.0, 2.0);
                points.add(Offset(lXY.a, lXY.b));
              }
            }
            // Update row/y value and offset by a few pixels
            wY += spikeRowOffset;
          }
        }
      }
      channel++;
    }

    // Now plot all mapped points.
    canvas.drawPoints(PointMode.points, points, paint);
  }
}
