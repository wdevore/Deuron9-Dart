import 'package:flutter/material.dart';

import '../model/appstate.dart';

class PropertiesTabWidget extends StatefulWidget {
  final AppState appState;

  const PropertiesTabWidget({super.key, required this.appState});

  @override
  State<PropertiesTabWidget> createState() => _PropertiesTabWidgetState();
}

class _PropertiesTabWidgetState extends State<PropertiesTabWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
