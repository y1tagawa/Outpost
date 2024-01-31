import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter_ditredi/polygon3d.dart';
import 'package:hello_flutter_ditredi/quad3d.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
//import 'package:vector_math/vector_math_64.dart' as vector_math show Colors;
import 'package:vector_math/vector_math_64.dart' hide Colors;

const _tileWidth = 1.0;
const _wallDepth = _tileWidth * 0.1;

final _d3dControllerProvider = ChangeNotifierProvider(
  (ref) => DiTreDiController(
    rotationX: 0.0,
    rotationY: 0.0,
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
      body: DiTreDiDraggable(
        controller: controller,
        child: DiTreDi(
          bounds: Aabb3.minMax(Vector3(-1, -1, 0), Vector3(1, 1, 3)),
          figures: [
            // Cube3D(2, Vector3(-3, 0, 0)),
            // Cube3D(2, Vector3(3, 0, 0)),
            // for (double x = -6; x <= 4.0; x += 4.0)
            //   for (double z = 0.0; z < 14.0; z += 4.0) Cube3D(2, Vector3(x, 0, z)),

            //Box3D(Aabb3.minMax(Vector3(0, 1, 0), Vector3(1, 2, 3))),

            Quad3D.fromVertices(
              Vector3(0, 0, 0),
              Vector3(1, 0, 0),
              Vector3(1, 1, 0),
              Vector3(0, 1, 0),
              color: Colors.black,
            ),
            ...Polygon3D(
              [
                Vector3(0.2, 0, -0.01),
                Vector3(0.2, 0.85, -0.01),
                Vector3(0.8, 0.85, -0.01),
                Vector3(0.8, 0, -0.01),
              ],
              closed: false,
              color: Colors.white,
            ).toLines(),
          ],
          controller: controller,
        ),
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
