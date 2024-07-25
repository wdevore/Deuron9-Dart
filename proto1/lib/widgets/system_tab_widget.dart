import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/appstate.dart';
import '../model/config_model.dart';
import '../model/model.dart';

const String _defaultExportFileName = 'Config.json';

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
                _exportGlobalConfig(appState);
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
                _export(appState);
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
                appState.createNeuron('Simulate');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: const Color.fromARGB(255, 104, 58, 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Tooltip(
                message: 'Create new Sim.',
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
// Export
// ---------------------------------------------------------
Future<String?> _showExportFileDialog() async {
  try {
    String? fileName = await FilePicker.platform.saveFile(
      allowedExtensions: ['json'],
      type: FileType.any,
      dialogTitle: 'Pick save file',
      fileName: _defaultExportFileName,
      initialDirectory: null,
      lockParentWindow: false,
    );

    return Future.value(fileName);
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print('Unsupported operation $e');
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }

  return Future.error('ImportExportError');
}

void _exportGlobalConfig(AppState appState) async {
  String? fileName = await _showExportFileDialog();
  if (fileName == null || fileName == 'ImportExportError') return;

  try {
    final File file = File(fileName);
    String json = appState.toStringConfig();

    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(json);

    await file.writeAsString(prettyprint);
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

// ---------------------------------------------------------
// Import
// ---------------------------------------------------------
Future<String> _showImportFileDialog() async {
  var filePath = p.join(Directory.current.path, 'data/');

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    initialDirectory: filePath,
    // onFileLoading: (FilePickerStatus status) =>
    //     debugPrint('Pick status: $status'),
    allowedExtensions: ['json'],
  );

  if (result != null) {
    String filePath = result.paths[0] as String;
    final File file = File(filePath);
    String json = file.readAsStringSync();

    return json;
  }

  return '';
}

void _importGlobalConfig(AppState appState) async {
  String json = await _showImportFileDialog();
  if (json.isEmpty) {
    if (kDebugMode) {
      print('json is empty');
    }
    return;
  }

  try {
    if (json.isNotEmpty) {
      Map<String, dynamic> map = jsonDecode(json);
      final model = ConfigModel.fromJson(map);

      appState.reset();
      appState.configModel = model;
      appState.update();
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

const String defaultExportFileName = 'SimModel.json';

// ---------------------------------------------------------
// Import
// ---------------------------------------------------------
void _import(AppState appState) async {
  String json = await _importStory();
  if (json.isNotEmpty) {
    Map<String, dynamic> map = jsonDecode(json);
    final model = Model.fromJson(map);

    appState.reset();
    appState.model = model;
    appState.dirty = true;
    appState.update();
  }
}

Future<String> _importStory() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    // onFileLoading: (FilePickerStatus status) =>
    //     debugPrint('Pick status: $status'),
    allowedExtensions: ['json'],
  );

  if (result != null) {
    PlatformFile pFile = result.files.first; //.single.readStream;
    try {
      String json = utf8.decode(pFile.bytes!.toList());
      return json;
    } catch (e, stackTrace) {
      debugPrintStack(label: e.toString(), stackTrace: stackTrace);
    }
  }

  return '';
}

// ---------------------------------------------------------
// Export
// ---------------------------------------------------------
Future<String> _exportDialog() async {
  try {
    String? fileName = await FilePicker.platform.saveFile(
      allowedExtensions: ['json'],
      type: FileType.any,
      dialogTitle: 'Pick save file',
      fileName: defaultExportFileName,
      initialDirectory: null,
      lockParentWindow: false,
    );

    if (fileName != null) {
      return Future.value(fileName);
    } else {
      return Future.value('Cancelled');
    }
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print('Unsupported operation $e');
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }

  return Future.error('ExportError');
}

void _export(AppState appState) async {
  String fileName = await _exportDialog();
  if (fileName == 'ExportError') return;
  if (fileName == 'Cancelled') return;

  try {
    final File file = File(fileName);
    String json = appState.toString();

    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(json);

    await file.writeAsString(prettyprint);
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}
