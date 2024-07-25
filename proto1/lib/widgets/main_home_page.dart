import 'package:flutter/material.dart';
import 'package:proto1/widgets/properties_tab_widget.dart';
import 'package:proto1/widgets/system_tab_widget.dart';
import 'package:provider/provider.dart';
import 'package:split_view/split_view.dart';

import '../model/appstate.dart';
import 'global_tab_widget.dart';
import 'spikes_graph_widget.dart';

const String defaultExportFileName = 'SimModel.json';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key, required this.title});

  final String title;

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Create Start simulation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade50,
              foregroundColor: const Color.fromARGB(255, 104, 58, 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Tooltip(
              message: 'Click to Begin simulation.',
              child: Text('Simulate'),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              // Reset simulation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade50,
              foregroundColor: const Color.fromARGB(255, 104, 58, 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Tooltip(
              message: 'Click to Reset simulation.',
              child: Text('Reset'),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              // Stop simulation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade50,
              foregroundColor: const Color.fromARGB(255, 104, 58, 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Tooltip(
              message: 'Click to Stop simulation.',
              child: Text('Stop'),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        indicator: const SplitIndicator(viewMode: SplitViewMode.Horizontal),
        activeIndicator: const SplitIndicator(
          viewMode: SplitViewMode.Horizontal,
          isActive: true,
          color: Colors.lime,
        ),
        controller: SplitViewController(
          weights: [0.7, 0.3], // Initial weights
          limits: [null, WeightLimit(min: 0.3, max: 0.7)], // Constraints
        ),
        children: [
          _buildGraphView(),
          _buildTabBar(appState),
        ],
      ),
    );
  }
}

Widget _buildGraphView() {
  final points = [
    const Offset(50, 150),
    const Offset(150, 75),
    const Offset(250, 250),
    const Offset(130, 200),
    const Offset(270, 100),
  ];

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SpikesGraphWidget(
          points: points,
          height: 200.0,
          bgColor: Colors.black87,
        ),
        SpikesGraphWidget(
          points: points,
          height: 300.0,
          bgColor: Colors.black54,
        ),
        SpikesGraphWidget(
          points: points,
          height: 200.0,
          bgColor: Colors.black45,
        ),
      ],
    ),
  );
}

Widget _buildTabBar(AppState appState) {
  return DefaultTabController(
    length: 3,
    child: Column(
      children: [
        const SizedBox(
          height: 50,
          child: TabBar(
            tabs: [
              Text(
                'Global',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Properties',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'System',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              GlobalTabWidget(appState: appState),
              PropertiesTabWidget(appState: appState),
              SystemTabWidget(appState: appState),
            ],
          ),
        )
      ],
    ),
  );
}
