import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:split_view/split_view.dart';

import '../main.dart';
import '../widgets/simulation_properties_tab_widget.dart';
import '../widgets/system_tab_widget.dart';
import '../model/appstate.dart';
import 'global_tab_widget.dart';
import 'graphs/soma_apfast_graph_widget.dart';
import 'graphs/soma_apslow_graph_widget.dart';
import 'graphs/soma_psp_graph_widget.dart';
import 'graphs/synapse_psp_graph_widget.dart';
import 'graphs/spikes_graph_widget.dart';
import 'graphs/synapse_surge_graph_widget.dart';
import 'graphs/synapse_weights_graph_widget.dart';

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
              simulation.run();
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
              simulation.reset();
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
          _buildGraphView(appState),
          _buildTabBar(appState),
        ],
      ),
    );
  }
}

Widget _buildGraphView(AppState appState) {
  return SingleChildScrollView(
    child: Consumer<SampleData>(
      builder: (BuildContext context, SampleData samplesData, Widget? child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Portal(
              child: PortalTarget(
                anchor: const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topLeft,
                  offset: Offset(5, 5),
                ),
                visible: true,
                portalFollower: const Text(
                  'Spikes',
                  style: TextStyle(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SpikesGraphWidget(
                    appState,
                    sampleData: samplesData,
                    height: 180.0,
                    bgColor: Colors.black87,
                  ),
                ),
              ),
            ),
            Portal(
              child: PortalTarget(
                anchor: const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topLeft,
                  offset: Offset(5, 5),
                ),
                visible: true,
                portalFollower: const Text(
                  'Synapse Surge',
                  style: TextStyle(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SynapseSurgeGraphWidget(
                    appState,
                    sampleData: samplesData,
                    height: 180.0,
                    bgColor: Colors.black54,
                  ),
                ),
              ),
            ),
            Portal(
              child: PortalTarget(
                anchor: const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topLeft,
                  offset: Offset(5, 5),
                ),
                visible: true,
                portalFollower: const Text(
                  'Synapse Psp',
                  style: TextStyle(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: PspGraphWidget(
                    appState,
                    sampleData: samplesData,
                    height: 180.0,
                    bgColor: Colors.black87,
                  ),
                ),
              ),
            ),
            Portal(
              child: PortalTarget(
                anchor: const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topLeft,
                  offset: Offset(5, 5),
                ),
                visible: true,
                portalFollower: const Text(
                  'Synapse Weights',
                  style: TextStyle(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SynapseWeightsGraphWidget(
                    appState,
                    sampleData: samplesData,
                    height: 180.0,
                    bgColor: Colors.black54,
                  ),
                ),
              ),
            ),
            Portal(
              child: PortalTarget(
                anchor: const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topLeft,
                  offset: Offset(5, 5),
                ),
                visible: true,
                portalFollower: const Text(
                  'Soma PSP',
                  style: TextStyle(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SomaPspGraphWidget(
                    appState,
                    sampleData: samplesData,
                    height: 180.0,
                    bgColor: Colors.black87,
                  ),
                ),
              ),
            ),
            Portal(
              child: PortalTarget(
                anchor: const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topLeft,
                  offset: Offset(5, 5),
                ),
                visible: true,
                portalFollower: const Text(
                  'Soma AP Fast',
                  style: TextStyle(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SomaAPFastGraphWidget(
                    appState,
                    sampleData: samplesData,
                    height: 180.0,
                    bgColor: Colors.black54,
                  ),
                ),
              ),
            ),
            Portal(
              child: PortalTarget(
                anchor: const Aligned(
                  follower: Alignment.topLeft,
                  target: Alignment.topLeft,
                  offset: Offset(5, 5),
                ),
                visible: true,
                portalFollower: const Text(
                  'Soma AP Slow',
                  style: TextStyle(color: Colors.white),
                ),
                child: SomaAPSlowGraphWidget(
                  appState,
                  sampleData: samplesData,
                  height: 180.0,
                  bgColor: Colors.black87,
                ),
              ),
            ),
          ],
        );
      },
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
                'Simulation',
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
              SimulationPropertiesTabWidget(appState: appState),
              SystemTabWidget(appState: appState),
            ],
          ),
        )
      ],
    ),
  );
}
