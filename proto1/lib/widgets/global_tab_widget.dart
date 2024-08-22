import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/config_model.dart';
import '../model/appstate.dart';
import '../model/environment.dart';
import '../model/model.dart';
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
  TextEditingController softAccelRangeValueController = TextEditingController();
  TextEditingController softCurveRangeValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    durationController.text = widget.appState.configModel.duration.toString();
    timeScaleController.text = widget.appState.configModel.timeScale.toString();
    rangeStartController.text =
        widget.appState.configModel.rangeStart.toString();
    rangeEndController.text = widget.appState.configModel.rangeEnd.toString();
    scrollVelocityController.text =
        widget.appState.configModel.scroll.toString();

    minRangeValueController.text =
        widget.appState.environment.minRangeValue.toString();
    maxRangeValueController.text =
        widget.appState.environment.maxRangeValue.toString();
    centerRangeValueController.text =
        widget.appState.environment.centerRangeValue.toString();
    softAccelRangeValueController.text =
        widget.appState.configModel.softAcceleration.toString();
    softCurveRangeValueController.text =
        widget.appState.configModel.softCurve.toString();

    return Column(
      children: [
        Consumer<ConfigModel>(
          builder: (context, configModel, child) {
            return Row(
              children: [
                IntFieldWidget(
                  controller: durationController,
                  label: 'Duration: ',
                  setValue: (int value) => configModel.duration = value,
                ),
                IntFieldWidget(
                  controller: timeScaleController,
                  label: 'TimeScale: ',
                  setValue: (int value) => configModel.timeScale = value,
                ),
              ],
            );
          },
        ),
        Consumer<ConfigModel>(
          builder: (context, configModel, child) {
            return Row(
              children: [
                IntFieldWidget(
                  controller: rangeStartController,
                  label: 'Range Start: ',
                  setValue: (int value) {
                    configModel.rangeStart = value;
                    widget.appState.update();
                  },
                ),
                IntFieldWidget(
                  controller: rangeEndController,
                  label: 'Range End: ',
                  setValue: (int value) {
                    configModel.rangeEnd = value;
                    widget.appState.update();
                  },
                ),
              ],
            );
          },
        ),
        Consumer<ConfigModel>(
          builder: (context, configModel, child) {
            return Row(
              children: [
                FloatFieldWidget(
                  controller: scrollVelocityController,
                  label: 'Scroll velocity: ',
                  setValue: (double value) => configModel.scroll = value,
                ),
              ],
            );
          },
        ),
        // Slider
        Consumer<Model>(
          builder: (BuildContext context, Model model, Widget? child) {
            return Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
                  child: Text(
                    'Synapse: ',
                  ),
                ),
                Text(
                  '(${model.activeSynapse.toString().padLeft(3, '0')})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Slider(
                    value: model.activeSynapse.toDouble(),
                    min: 1,
                    max: model.synapses.toDouble(),
                    divisions: 100,
                    onChanged: (value) {
                      model.activeSynapse = value.toInt();
                      widget.appState.update();
                    },
                    // onChangeEnd: (value) => configWidget.config.aplay(),
                  ),
                )
              ],
            );
          },
        ),
        Consumer<Environment>(
          builder: (context, environment, child) {
            return Row(
              children: [
                FloatFieldWidget(
                  controller: minRangeValueController,
                  label: 'Min Value: ',
                  setValue: (double value) => environment.minRangeValue = value,
                ),
                FloatFieldWidget(
                  controller: maxRangeValueController,
                  label: 'Max Value: ',
                  setValue: (double value) => environment.maxRangeValue = value,
                ),
                FloatFieldWidget(
                  controller: centerRangeValueController,
                  label: 'Max Value: ',
                  setValue: (double value) =>
                      environment.centerRangeValue = value,
                ),
              ],
            );
          },
        ),
        const Divider(),
        Consumer<Environment>(
          builder: (context, environment, child) {
            return Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Presets'),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: environment.initialWeights,
                      onChanged: (value) {
                        environment.initialWeights = value!;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Current'),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: environment.initialWeights,
                      onChanged: (value) {
                        environment.initialWeights = value!;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Random'),
                    leading: Radio<int>(
                      value: 2,
                      groupValue: environment.initialWeights,
                      onChanged: (value) {
                        environment.initialWeights = value!;
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const Divider(),
        Consumer<Environment>(
          builder: (context, environment, child) {
            return Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Hard Bounds'),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: environment.weightBounding,
                      onChanged: (value) {
                        environment.weightBounding = value!;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Soft Bounds'),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: environment.weightBounding,
                      onChanged: (value) {
                        environment.weightBounding = value!;
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const Divider(),
        Consumer<ConfigModel>(
          builder: (context, configModel, child) {
            return Row(
              children: [
                FloatFieldWidget(
                  controller: softAccelRangeValueController,
                  label: 'Soft Accelleration: ',
                  setValue: (double value) =>
                      configModel.softAcceleration = value,
                ),
                FloatFieldWidget(
                  controller: softCurveRangeValueController,
                  label: 'Soft Curve: ',
                  setValue: (double value) => configModel.softCurve = value,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
