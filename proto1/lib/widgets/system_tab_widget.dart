import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:proto1/io_utils.dart';

import '../model/appstate.dart';
import '../model/config_model.dart';
import '../model/model.dart';

class SystemTabWidget extends StatelessWidget {
  final AppState appState;

  const SystemTabWidget({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                _importGlobalConfig(appState);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: const Color.fromARGB(255, 104, 58, 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Tooltip(
                  message: 'Import Global config to external file.',
                  waitDuration: Durations.long1,
                  child: Text('Import Config')),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                var filePath = p.join(Directory.current.path, 'data/');
                IOUtils.export(
                    appState.configModel.toJson(), 'config.json', filePath,
                    showDialog: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: const Color.fromARGB(255, 104, 58, 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Tooltip(
                  message: 'Export Global config to external file.',
                  waitDuration: Durations.long1,
                  child: Text('Export Config')),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                // Import. Open file dialog
                _import(appState);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: const Color.fromARGB(255, 104, 58, 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Tooltip(
                message: 'Import external sim model.',
                waitDuration: Durations.long1,
                child: Text('Import Sim Model'),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                // _export(appState);
                var filePath = p.join(Directory.current.path, 'data/');
                IOUtils.export(appState.toString(), 'SimModel.json', filePath,
                    showDialog: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: const Color.fromARGB(255, 104, 58, 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Tooltip(
                  message: 'Export Sim to external file.',
                  waitDuration: Durations.long1,
                  child: Text('Export Sim Model')),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                // Create a baseline sim config
                appState.createNeuron();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: const Color.fromARGB(255, 104, 58, 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Tooltip(
                message: 'Create new Neuron.',
                waitDuration: Durations.long1,
                child: Text('New'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// Import Global
// ---------------------------------------------------------
void _importGlobalConfig(AppState appState) async {
  var filePath = p.join(Directory.current.path, 'data/');
  var map = await IOUtils.importData(filePath, showDialog: true);
  if (map != null) {
    final model = ConfigModel.fromJson(map);

    appState.reset();
    appState.configModel = model;
    appState.update();
  }
}

const String defaultExportFileName = 'SimModel.json';

// ---------------------------------------------------------
// Import model
// ---------------------------------------------------------
void _import(AppState appState) async {
  var filePath = p.join(Directory.current.path, 'data/');
  var map = await IOUtils.importData(filePath, showDialog: true);
  if (map != null) {
    final model = Model.fromJson(map);

    appState.reset();
    appState.model = model;
    appState.dirty = true;
    appState.update();
  }
}
