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
    panels.add(_buildNeuronPanel(appState));
    panels.add(_buildDendritePanel(appState));
    panels.add(_buildCompartmentPanel(appState));
    panels.add(_buildSynapsePanel(appState));
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
      padding: const EdgeInsets.all(5.0),
      child: ExpansionPanelList(
        dividerColor: Colors.blue.shade400,
        expandedHeaderPadding: const EdgeInsets.all(2.0),
        materialGapSize: 3.0,
        expandIconColor: Colors.blue.shade700,
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            widget.panels[panelIndex].isExpanded = isExpanded;
          });
        },
        children: widget.panels.map<ExpansionPanel>(
          (SimPropPanel sp) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 2.0, 0.0, 0.0),
                  child: Text(sp.headerValue),
                );
              },
              body: sp.expandedValue,
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
              setValue: (double value) {
                configModel.stimulusScaler = value;
              },
              // cursorPos: stimScalerController.selection.base.offset,
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

SimPropPanel _buildNeuronPanel(AppState appState) {
  TextEditingController firingRateController = TextEditingController();
  TextEditingController patternMinController = TextEditingController();
  TextEditingController patternMaxController = TextEditingController();

  TextEditingController refractPerController = TextEditingController();
  TextEditingController thresholdController = TextEditingController();
  TextEditingController apMaxController = TextEditingController();

  TextEditingController fastSurgeController = TextEditingController();
  TextEditingController slowSurgeController = TextEditingController();

  TextEditingController taoController = TextEditingController();
  TextEditingController taoJController = TextEditingController();
  TextEditingController taoSController = TextEditingController();

  firingRateController.text = appState.model.noiseLambda.toString();
  patternMinController.text = appState.model.poissonPatternMin.toString();
  patternMaxController.text = appState.model.poissonPatternMax.toString();

  refractPerController.text = appState.model.neuron.refractoryPeriod.toString();
  thresholdController.text = appState.model.neuron.threshold.toString();
  apMaxController.text = appState.model.neuron.aPMax.toString();

  fastSurgeController.text = appState.model.neuron.fastSurge.toString();
  slowSurgeController.text = appState.model.neuron.slowSurge.toString();

  taoController.text = appState.model.neuron.tao.toString();
  taoJController.text = appState.model.neuron.taoJ.toString();
  taoSController.text = appState.model.neuron.taoS.toString();

  return SimPropPanel(
    headerValue: 'Neuron',
    expandedValue: Consumer<Neuron>(
      builder: (context, neuron, child) {
        return Column(
          mainAxisSize:
              MainAxisSize.min, // This is needed for the Flexibles below.
          children: [
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: refractPerController,
                    label: 'Refractory Period: ',
                    setValue: (double value) => neuron.refractoryPeriod = value,
                  ),
                  FloatFieldWidget(
                    controller: thresholdController,
                    label: 'Threshold: ',
                    setValue: (double value) => neuron.threshold = value,
                  ),
                  FloatFieldWidget(
                    controller: apMaxController,
                    label: 'APMax: ',
                    setValue: (double value) => neuron.aPMax = value,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: fastSurgeController,
                    label: 'Fast Surge: ',
                    setValue: (double value) => neuron.fastSurge = value,
                  ),
                  FloatFieldWidget(
                    controller: slowSurgeController,
                    label: 'Slow Surge: ',
                    setValue: (double value) => neuron.slowSurge = value,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: taoController,
                    label: 'Tao: ',
                    setValue: (double value) => neuron.tao = value,
                  ),
                  FloatFieldWidget(
                    controller: taoJController,
                    label: 'Tao J: ',
                    setValue: (double value) => neuron.taoJ = value,
                  ),
                  FloatFieldWidget(
                    controller: taoSController,
                    label: 'Tao S: ',
                    setValue: (double value) => neuron.taoS = value,
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

SimPropPanel _buildDendritePanel(AppState appState) {
  TextEditingController taoEffController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController minPSPController = TextEditingController();

  taoEffController.text = appState.model.neuron.dendrite.taoEff.toString();
  lengthController.text = appState.model.neuron.dendrite.length.toString();
  minPSPController.text = appState.model.neuron.dendrite.minPSPValue.toString();

  return SimPropPanel(
    headerValue: 'Dendrite',
    expandedValue: Consumer<Dendrite>(
      builder: (context, dendrite, child) {
        return Column(
          mainAxisSize:
              MainAxisSize.min, // This is needed for the Flexibles below.
          children: [
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: taoEffController,
                    label: 'tao Eff: ',
                    setValue: (double value) => dendrite.taoEff = value,
                  ),
                  FloatFieldWidget(
                    controller: lengthController,
                    label: 'Length: ',
                    setValue: (double value) => dendrite.length = value,
                  ),
                  FloatFieldWidget(
                    controller: minPSPController,
                    label: 'MinPSP: ',
                    setValue: (double value) => dendrite.minPSPValue = value,
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

SimPropPanel _buildCompartmentPanel(AppState appState) {
  TextEditingController weightMinController = TextEditingController();
  TextEditingController weightMaxController = TextEditingController();

  weightMinController.text =
      appState.model.neuron.dendrite.compartment.weightMin.toString();
  weightMaxController.text =
      appState.model.neuron.dendrite.compartment.weightMax.toString();

  return SimPropPanel(
    headerValue: 'Compartment',
    expandedValue: Consumer<Compartment>(
      builder: (context, compartment, child) {
        return Column(
          mainAxisSize:
              MainAxisSize.min, // This is needed for the Flexibles below.
          children: [
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: weightMinController,
                    label: 'Weight Min: ',
                    setValue: (double value) => compartment.weightMin = value,
                  ),
                  FloatFieldWidget(
                    controller: weightMaxController,
                    label: 'Weight Max: ',
                    setValue: (double value) => compartment.weightMax = value,
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

SimPropPanel _buildSynapsePanel(AppState appState) {
  TextEditingController alphaController = TextEditingController();
  TextEditingController amaController = TextEditingController();
  TextEditingController ambController = TextEditingController();

  Synapse syn = appState.model.neuron.dendrite.compartment.synapse;
  alphaController.text = syn.alpha.toString();
  amaController.text = syn.ama.toString();
  ambController.text = syn.amb.toString();

  TextEditingController lamdaController = TextEditingController();
  TextEditingController fastLearnController = TextEditingController();
  TextEditingController slowLeanController = TextEditingController();

  lamdaController.text = syn.lambda.toString();
  fastLearnController.text = syn.learningRateFast.toString();
  slowLeanController.text = syn.learningRateSlow.toString();

  TextEditingController muController = TextEditingController();
  TextEditingController taoIController = TextEditingController();
  TextEditingController taoNController = TextEditingController();

  muController.text = syn.mu.toString();
  taoIController.text = syn.taoI.toString();
  taoNController.text = syn.taoN.toString();

  TextEditingController taoPController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  taoPController.text = syn.taoP.toString();
  weightController.text = syn.w.toString();

  return SimPropPanel(
    headerValue: 'Synapse',
    expandedValue: Consumer<Synapse>(
      builder: (context, synapse, child) {
        return Column(
          mainAxisSize:
              MainAxisSize.min, // This is needed for the Flexibles below.
          children: [
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: alphaController,
                    label: 'Alpha: ',
                    setValue: (double value) => synapse.alpha = value,
                  ),
                  FloatFieldWidget(
                    controller: amaController,
                    label: 'Ama: ',
                    setValue: (double value) => synapse.ama = value,
                  ),
                  FloatFieldWidget(
                    controller: ambController,
                    label: 'Amb: ',
                    setValue: (double value) => synapse.amb = value,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: lamdaController,
                    label: 'Lambda: ',
                    setValue: (double value) => synapse.lambda = value,
                  ),
                  FloatFieldWidget(
                    controller: fastLearnController,
                    label: 'Fast Learn Rate: ',
                    setValue: (double value) =>
                        synapse.learningRateFast = value,
                  ),
                  FloatFieldWidget(
                    controller: slowLeanController,
                    label: 'Slow Learn Rate: ',
                    setValue: (double value) =>
                        synapse.learningRateSlow = value,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: muController,
                    label: 'Mu: ',
                    setValue: (double value) => synapse.mu = value,
                  ),
                  FloatFieldWidget(
                    controller: taoIController,
                    label: 'TaoI: ',
                    setValue: (double value) => synapse.taoI = value,
                  ),
                  FloatFieldWidget(
                    controller: taoNController,
                    label: 'TaoN: ',
                    setValue: (double value) => synapse.taoN = value,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  FloatFieldWidget(
                    controller: taoPController,
                    label: 'TaoP: ',
                    setValue: (double value) => synapse.taoP = value,
                  ),
                  FloatFieldWidget(
                    controller: weightController,
                    label: 'Weight: ',
                    setValue: (double value) => synapse.w = value,
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
