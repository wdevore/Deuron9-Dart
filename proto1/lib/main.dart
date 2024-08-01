import 'package:flutter/material.dart';
import 'package:proto1/model/appstate.dart';
import 'package:provider/provider.dart';
// import 'package:window_manager/window_manager.dart';

import 'widgets/main_home_page.dart';

final AppState _appState = AppState.create();

void main() async {
  // setupWindow();
  await _appState.initialize();

  // NOTE: RetroVibrato has an example of using a MultiProvider lower in the
  // widget tree closer to usage site. This improves update traversal
  // tree queries.
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: _appState,
      ),
      ChangeNotifierProvider.value(
        value: _appState.environment,
      ),
      ChangeNotifierProvider.value(
        value: _appState.configModel,
      ),
      ChangeNotifierProvider.value(
        value: _appState.model,
      ),
      ChangeNotifierProvider.value(
        value: _appState.model.neuron,
      ),
      ChangeNotifierProvider.value(
        value: _appState.model.neuron.dendrite,
      ),
      ChangeNotifierProvider.value(
        value: _appState.model.neuron.dendrite.compartment,
      ),
      ChangeNotifierProvider.value(
        value: _appState.model.neuron.dendrite.compartment.synapse,
      ),
    ],
    child: const SimApp(),
  ));

  // runApp(
  //   ChangeNotifierProvider.value(
  //     value: _appState,
  //     child: const SimApp(),
  //   ),
  // );
}

class SimApp extends StatelessWidget {
  const SimApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deuron9',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainHomePage(title: 'Deuron9'),
    );
  }
}

// const double windowWidth = 1020;
// const double windowHeight = 576;

// NOTE: This is broken during pub fetch. Just enabled the entry pubspec
// cause the linux code to crash. It could that the code is on an external
// SSD and not on the main M2 SSD.
void setupWindow() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // // Must add this line.
  // await windowManager.ensureInitialized();

  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(800, 600),
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.hidden,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });

  // if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   setWindowTitle('Deuron9');
  //   setWindowMinSize(const Size(windowWidth, windowHeight));
  //   setWindowMaxSize(const Size(windowWidth, windowHeight));
  //   getCurrentScreen().then((screen) {
  //     setWindowFrame(Rect.fromCenter(
  //       center: screen!.frame.center,
  //       width: windowWidth,
  //       height: windowHeight,
  //     ));
  //   });
  // }
}
