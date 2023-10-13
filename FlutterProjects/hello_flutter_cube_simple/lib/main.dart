// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Hello Flutter Cube'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSceneCreated(Scene scene) {
      scene.camera.position.x = 3;
      scene.camera.position.y = 2;
      scene.camera.position.z = 3;
      scene.camera.fov = 45;

      final cube = Object(
        position: Vector3.zero(),
        backfaceCulling: true,
        fileName: 'assets/cube/cube.obj',
      );
      scene.world.add(cube);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Cube(
        onSceneCreated: onSceneCreated,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
