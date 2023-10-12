// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final _random = Random();

// 質点間に働く力の結合定数
const _f = -0.01;

// 質点数
const _pointCount = 100;

Vector3 _fling() {
  return Vector3(
    _random.nextDouble() + 0.1,
    _random.nextDouble() + 0.1,
    _random.nextDouble() + 0.1,
  );
}

// シミュレーション世代
int _generation = 1;

// 質点位置
final _pointsProvider = StateProvider<List<Vector3>>(
  (ref) => List<Vector3>.generate(_pointCount, (int i) => _fling()),
);

final _pausedProvider = StateProvider<bool>((ref) => false);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Hello Flutter Cube'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late Scene _scene;
  late Object _center;

  @override
  Widget build(BuildContext context) {
    final points = ref.watch(_pointsProvider);
    final paused = ref.watch(_pausedProvider);

    // シミュレーション画面初期化
    void onSceneCreated(Scene scene) {
      _scene = scene;

      scene.camera.position.z = 8;
      scene.camera.fov = 45;

      _center = Object(
        position: Vector3.zero(),
      );
      _scene.world.add(_center);
    }

    // 質点位置更新
    void updatePoints() {
      final t = <Vector3>[];

      nextPoint:
      for (int i = 0; i < _pointCount; ++i) {
        // 質点を半径1の球面上に移動する。
        final r = points[i].length;
        if (r < 0.01) {
          // ただし中心に近すぎる場合、ランダムな位置に飛ばす。
          t.add(_fling());
          continue nextPoint;
        }
        final p = points[i] * (1.0 / r);
        // 球面上の質点に、他の質点からの力を加える。
        Vector3 delta = Vector3.zero();
        for (int j = 0; j < _pointCount; ++j) {
          if (j == i) {
            continue;
          }
          final d = points[j] - points[i];
          final r = d.length;
          if (r < 0.01) {
            // ただし他の点に近すぎる場合、ランダムな位置に飛ばす。
            t.add(_fling());
            continue nextPoint;
          }
          // 向きはd,大きさは距離の2乗に反比例する力（_f * (d / r) * r**-2）
          delta += (d * _f) / (r * r * r);
        }
        t.add(p + delta);
      }
      // 質点の位置を更新する。
      ref.watch(_pointsProvider.notifier).state = t;
      ++_generation;

      if (_generation == 100) {
        final t = StringBuffer();
        for (int i = 0; i < _pointCount; ++i) {
          final p = points[i];
          t.write('[$i] (${p.x.toStringAsFixed(4)}, '
              '${p.y.toStringAsFixed(4)}, '
              '${p.z.toStringAsFixed(4)})\n');
        }
        Logger().i(t.toString());
      }
    }

    // シミュレーション画面更新
    void updateScene() {
      for (int i = _center.children.length - 1; i >= 0; --i) {
        _center.remove(_center.children[i]);
      }
      for (int i = 0; i < _pointCount; ++i) {
        final marker = Object(
          position: points[i],
          scale: Vector3(0.05, 0.05, 0.05),
          backfaceCulling: true,
          fileName: 'assets/marker.obj',
        );
        _center.add(marker);
      }
      _scene.update();
    }

    if (!paused) {
      // 次の更新を予約する。
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          updatePoints();
          updateScene();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Text('time: $_generation'),
          Expanded(
            child: Cube(
              onSceneCreated: onSceneCreated,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.watch(_pausedProvider.notifier).state = !paused;
        },
        child: Icon(paused ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}
