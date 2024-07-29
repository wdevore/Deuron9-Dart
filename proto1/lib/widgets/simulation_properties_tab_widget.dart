import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/appstate.dart';
import '../model/config_model.dart';
import '../model/model.dart';
import 'float_field_widget.dart';
import 'int_field_widget.dart';

class SimPropPanel {
  Widget expandedValue;
  String headerValue;
  bool isExpanded;

  SimPropPanel({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });
}

class SimulationPropertiesTabWidget extends StatefulWidget {
  final AppState appState;
  final List<SimPropPanel> panels = [];

  SimulationPropertiesTabWidget({super.key, required this.appState}) {
    panels.add(_buildSimGlobalPanel(appState));
    panels.add(_buildPoissonPanel(appState));
  }

  @override
  State<SimulationPropertiesTabWidget> createState() =>
      _SimulationPropertiesTabWidgetState();
}

class _SimulationPropertiesTabWidgetState
    extends State<SimulationPropertiesTabWidget> {
  TextEditingController stimScalerController = TextEditingController();
  TextEditingController hertzController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            widget.panels[panelIndex].isExpanded = isExpanded;
          });
        },
        children: widget.panels.map<ExpansionPanel>(
          (SimPropPanel sp) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(sp.headerValue),
                );
              },
              body: sp.expandedValue,
              // body: Text('lakjsdlkja'),
              isExpanded: sp.isExpanded,
            );
          },
        ).toList(),
      ),
    );
  }
}

SimPropPanel _buildSimGlobalPanel(AppState appState) {
  TextEditingController stimScalerController = TextEditingController();
  TextEditingController hertzController = TextEditingController();

  stimScalerController.text = appState.configModel.stimulusScaler.toString();
  hertzController.text = appState.model.hertz.toString();

  return SimPropPanel(
    headerValue: 'Simulation Global',
    expandedValue: Row(
      children: [
        Consumer<ConfigModel>(
          builder: (context, configModel, child) {
            return FloatFieldWidget(
              controller: stimScalerController,
              label: 'Stimulus scaler: ',
              setValue: (double value) => configModel.stimulusScaler = value,
            );
          },
        ),
        Consumer<Model>(
          builder: (context, model, child) {
            return IntFieldWidget(
              controller: hertzController,
              label: 'Hertz: ',
              setValue: (int value) => model.hertz = value,
            );
          },
        ),
      ],
    ),
  );
}

SimPropPanel _buildPoissonPanel(AppState appState) {
  TextEditingController firingRateController = TextEditingController();
  TextEditingController patternMinController = TextEditingController();
  TextEditingController patternMaxController = TextEditingController();

  firingRateController.text = appState.model.noiseLambda.toString();
  patternMinController.text = appState.model.poissonPatternMin.toString();
  patternMaxController.text = appState.model.poissonPatternMax.toString();

  return SimPropPanel(
    headerValue: 'Poisson',
    expandedValue: Consumer<Model>(
      builder: (context, model, child) {
        return Column(
          mainAxisSize:
              MainAxisSize.min, // This is needed for the Flexibles below.
          children: [
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: firingRateController,
                    label: 'Firing Rate: ',
                    setValue: (double value) => model.noiseLambda = value,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: patternMinController,
                    label: 'Pattern Min: ',
                    setValue: (double value) => model.poissonPatternMin = value,
                  ),
                  FloatFieldWidget(
                    controller: patternMaxController,
                    label: 'Pattern Max: ',
                    setValue: (double value) => model.poissonPatternMax = value,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}
