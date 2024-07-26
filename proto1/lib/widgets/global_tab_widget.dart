import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/appstate.dart';

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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.configModel != null) {
      durationController.text = appState.configModel!.duration.toString();
      timeScaleController.text = appState.configModel!.timeScale.toString();
      rangeStartController.text = appState.configModel!.rangeStart.toString();
      rangeEndController.text = appState.configModel!.rangeEnd.toString();
      scrollVelocityController.text = appState.configModel!.scroll.toString();
    }

    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
              child: Text('Duration:'),
            ),
            Expanded(
              child: TextField(
                controller: durationController,
                onChanged: (value) {
                  appState.configModel!.duration = int.parse(value);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
              child: Text('TimeScale:'),
            ),
            Expanded(
              child: TextField(
                controller: timeScaleController,
                onChanged: (value) {
                  appState.configModel!.timeScale = int.parse(value);
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
              child: Text('Range Start:'),
            ),
            Expanded(
              child: TextField(
                controller: rangeStartController,
                onChanged: (value) {
                  appState.configModel!.rangeStart = int.parse(value);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
              child: Text('Range End:'),
            ),
            Expanded(
              child: TextField(
                controller: rangeEndController,
                onChanged: (value) {
                  appState.configModel!.rangeEnd = int.parse(value);
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
              child: Text('Scroll velocity:'),
            ),
            Expanded(
              child: TextField(
                controller: scrollVelocityController,
                onChanged: (value) {
                  appState.configModel!.scroll = double.parse(value);
                },
              ),
            ),
          ],
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
                    max: 100,
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
        )
      ],
    );
  }
}
