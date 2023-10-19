// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final logger = Logger('hello_flutter_cube_simple');

final sceneProvider = StateProvider<Scene?>((ref) => null);
final textureOnProvider = StateProvider<bool>((ref) => true);

Object? _cube;
Object? _cube2;

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
      title: 'Hello Flutter \'Cube\'',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Hello Flutter \'Cube\''),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scene = ref.watch(sceneProvider);
    final textureOn = ref.watch(textureOnProvider);

    void onSceneCreated(Scene scene) {
      scene.camera.position.setValues(3, 2, 3);
      scene.camera.fov = 45;

      _cube = Object(
        position: Vector3.zero(),
        backfaceCulling: true,
        fileName: 'assets/cube/cube.obj',
      );
      _cube2 = Object(
        position: Vector3.zero(),
        backfaceCulling: true,
        fileName: 'assets/cube/cube2.obj',
      );
      scene.world.add(textureOn ? _cube! : _cube2!);
      ref.read(sceneProvider.notifier).state = scene;
    }

    if (scene != null) {
      final (show, hide) = textureOn ? (_cube, _cube2) : (_cube2, _cube);
      if (scene.world.children.contains(hide!)) {
        scene.world.remove(hide);
      }
      if (!scene.world.children.contains(show!)) {
        scene.world.add(show);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(textureOnProvider.notifier).state = !textureOn;
            },
            icon: const Icon(Icons.onetwothree),
          ),
        ],
      ),
      body: Cube(
        onSceneCreated: onSceneCreated,
      ),
    );
  }
}
