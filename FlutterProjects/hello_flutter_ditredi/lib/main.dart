import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as material show Colors;
import 'package:flutter/material.dart' hide Colors;
import 'package:vector_math/vector_math_64.dart';

void main() {
  runApp(const MyApp());
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DiTreDiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DiTreDiController(rotationX: 0.0, rotationY: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: DiTreDi(
        figures: [
          Cube3D(2, Vector3(0, 0, 0)),
        ],
        controller: _controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.update(
            rotationY: _controller.rotationY + 10.0,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
