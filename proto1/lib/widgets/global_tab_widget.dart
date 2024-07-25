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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.configModel != null) {
      durationController.text = appState.configModel!.duration.toString();
      timeScaleController.text = appState.configModel!.timeScale.toString();
    }

    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
              child: Text('Duration: '),
            ),
            Expanded(
              child: TextField(
                controller: durationController,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 5, 4),
              child: Text('TimeScale: '),
            ),
            Expanded(
              child: TextField(
                controller: timeScaleController,
              ),
            ),
          ],
        )
      ],
    );
  }
}
