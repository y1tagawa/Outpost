import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as material show Colors;
import 'package:flutter/material.dart' hide Colors;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:vector_math/vector_math_64.dart';

final _d3dControllerProvider = ChangeNotifierProvider(
  (ref) => DiTreDiController(
    rotationX: 0.0,
    rotationY: 0.0,
    //translation: const Offset(0, 0),
  ),
);

final _logger = Logger('hello_flutter_two_dimensional');

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: material.Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_d3dControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: DiTreDi(
        figures: [
          for (double x = -12.0; x < 12.0; x += 3.0)
            for (double z = 0.0; z < 20.0; z += 3.0) Cube3D(2, Vector3(x, 0, z)),
        ],
        controller: controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.update(
            rotationY: controller.rotationY + 10.0,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
