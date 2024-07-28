import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/appstate.dart';
import 'float_field_widget.dart';
import 'int_field_widget.dart';

class GlobalTabWidget extends StatefulWidget {
  final AppState appState;

  const GlobalTabWidget({super.key, required this.appState});

  @override
  State<GlobalTabWidget> createState() => _GlobalTabWidgetState();
}

class _GlobalTabWidgetState extends State<GlobalTabWidget> {
  TextEditingController durationController = TextEditingController();
  TextEditingController timeScaleController = TextEditingController();
  TextEditingController rangeStartController = TextEditingController();
  TextEditingController rangeEndController = TextEditingController();
  TextEditingController scrollVelocityController = TextEditingController();
  TextEditingController minRangeValueController = TextEditingController();
  TextEditingController maxRangeValueController = TextEditingController();
  TextEditingController centerRangeValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.appState.configModel != null) {
      durationController.text =
          widget.appState.configModel!.duration.toString();
      timeScaleController.text =
          widget.appState.configModel!.timeScale.toString();
      rangeStartController.text =
          widget.appState.configModel!.rangeStart.toString();
      rangeEndController.text =
          widget.appState.configModel!.rangeEnd.toString();
      scrollVelocityController.text =
          widget.appState.configModel!.scroll.toString();
    }

    minRangeValueController.text = widget.appState.minRangeValue.toString();
    maxRangeValueController.text = widget.appState.maxRangeValue.toString();
    centerRangeValueController.text =
        widget.appState.centerRangeValue.toString();

    return Column(
      children: [
        Consumer<AppState>(
          builder: (context, appState, child) {
            return Row(
              children: [
                IntFieldWidget(
                  appState: appState,
                  controller: durationController,
                  label: 'Duration: ',
                  setValue: (int value) =>
                      appState.configModel!.duration = value,
                ),
                IntFieldWidget(
                  appState: appState,
                  controller: timeScaleController,
                  label: 'TimeScale: ',
                  setValue: (int value) =>
                      appState.configModel!.timeScale = value,
                ),
              ],
            );
          },
        ),
        Consumer<AppState>(
          builder: (context, appState, child) {
            return Row(
              children: [
                IntFieldWidget(
                  appState: appState,
                  controller: rangeStartController,
                  label: 'Range Start: ',
                  setValue: (int value) =>
                      appState.configModel!.rangeStart = value,
                ),
                IntFieldWidget(
                  appState: appState,
                  controller: rangeEndController,
                  label: 'Range End: ',
                  setValue: (int value) =>
                      appState.configModel!.rangeEnd = value,
                ),
              ],
            );
          },
        ),
        Consumer<AppState>(
          builder: (context, appState, child) {
            return Row(
              children: [
                FloatFieldWidget(
                  appState: appState,
                  controller: scrollVelocityController,
                  label: 'Scroll velocity: ',
                  setValue: (double value) =>
                      appState.configModel!.scroll = value,
                ),
              ],
            );
          },
        ),
        // Slider
        Consumer<AppState>(
          builder: (BuildContext context, AppState appState, Widget? child) {
            return Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
                  child: Text(
                    'Synapse: ',
                  ),
                ),
                Text(
                  '(${appState.activeSynapse.toString().padLeft(3, '0')})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Slider(
                    value: appState.activeSynapse.toDouble(),
                    min: 1,
                    max: appState.model!.synapses.toDouble(),
                    divisions: 100,
                    onChanged: (value) {
                      appState.activeSynapse = value.toInt();
                    },
                    // onChangeEnd: (value) => configWidget.config.aplay(),
                  ),
                )
              ],
            );
          },
        ),
        Consumer<AppState>(
          builder: (context, appState, child) {
            return Row(
              children: [
                FloatFieldWidget(
                  appState: appState,
                  controller: minRangeValueController,
                  label: 'Min Value: ',
                  setValue: (double value) => appState.minRangeValue = value,
                ),
                FloatFieldWidget(
                  appState: appState,
                  controller: maxRangeValueController,
                  label: 'Max Value: ',
                  setValue: (double value) => appState.maxRangeValue = value,
                ),
                FloatFieldWidget(
                  appState: appState,
                  controller: centerRangeValueController,
                  label: 'Max Value: ',
                  setValue: (double value) => appState.centerRangeValue = value,
                ),
              ],
            );
          },
        ),
        Consumer<AppState>(
          builder: (context, appState, child) {
            return Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Hard Bounds'),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: appState.weightBounding,
                      onChanged: (value) {
                        appState.weightBounding = value!;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Soft Bounds'),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: appState.weightBounding,
                      onChanged: (value) {
                        appState.weightBounding = value!;
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
