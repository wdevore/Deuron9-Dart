import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------
// Exports
// ---------------------------------------------------------

class IOUtils {
  static Future<String?> showExportFileDialog(String filename) async {
    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: ['json'],
        type: FileType.any,
        dialogTitle: 'Export file',
        fileName: filename,
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

  static void exportData(String json, String filename) async {
    String? fileName = await showExportFileDialog(filename);
    if (fileName == null || fileName == 'ImportExportError') return;

    try {
      final File file = File(fileName);

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
  // Imports
  // ---------------------------------------------------------
  static Future<String?> showImportFileDialog(String filePath) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      initialDirectory: filePath,
      // onFileLoading: (FilePickerStatus status) =>
      //     debugPrint('Pick status: $status'),
      allowedExtensions: ['json'],
    );

    if (result != null) {
      return result.paths[0];
    }

    return Future.value(null);
  }

  static Future<Map<String, dynamic>?> importData(String filePath,
      {bool showDialog = false}) async {
    String? filename;

    if (showDialog) {
      filename = await showImportFileDialog(filePath);
      if (filename == null || filename.isEmpty) {
        if (kDebugMode) {
          print('filePath is empty');
        }
        return Future.value(null);
      }
    } else {
      filename = filePath;
    }

    final File file = File(filename);
    String json = file.readAsStringSync();

    try {
      if (json.isNotEmpty) {
        Map<String, dynamic> map = jsonDecode(json);
        return Future.value(map);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return Future.value(null);
  }

  // ---------------------------------------------------------
  // Exports
  // ---------------------------------------------------------
  static Future<String> exportDialog(String fileName, String filePath) async {
    try {
      String? file = await FilePicker.platform.saveFile(
        allowedExtensions: ['json'],
        type: FileType.any,
        dialogTitle: 'Pick save file',
        fileName: fileName,
        initialDirectory: filePath,
        lockParentWindow: false,
      );

      if (file != null) {
        return Future.value(file);
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

  static void export(Object data, String fileName, String filePath,
      {bool showDialog = false}) async {
    String file = '';

    if (showDialog) {
      file = await exportDialog(fileName, filePath);
      if (file == 'ExportError') return;
      if (file == 'Cancelled') return;
    } else {
      file = filePath;
    }

    try {
      final File writeFile = File(file);

      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(data);

      await writeFile.writeAsString(prettyprint);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
