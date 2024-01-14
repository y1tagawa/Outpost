// Copyright 2024 Yoshinori Tagawa. All rights reserved.

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import 'grid_data.dart';
import 'scope_functions.dart';

const _squareDimension = 100.0;
const _scales = [0.25, 0.5, 0.75, 1.0];

const _paintImageAssets = [
  'assets/images/floor.png',
  'assets/images/rock.png',
  'assets/images/water.png',
  'assets/images/water.png',
  'assets/images/wall.png',
  'assets/images/path.png',
  'assets/images/door.png',
];

final _logger = Logger('hello_flutter_two_dimensional');

class _InitData {
  final int defaultColumnCount;
  final int defaultRowCount;

  const _InitData({
    required this.defaultColumnCount,
    required this.defaultRowCount,
  });
}

final _initDataProvider = FutureProvider((ref) async {
  final json = jsonDecode(
    await rootBundle.loadString('assets/init_data.json'),
  ) as Map<String, Object?>;

  final defaultColumnCount = (json['default_column_count']! as int).let((it) {
    assert(it >= 1);
    return it;
  });

  final defaultRowCount = (json['default_row_count']! as int).let((it) {
    assert(it >= 1);
    return it;
  });

  return _InitData(
    defaultColumnCount: defaultColumnCount,
    defaultRowCount: defaultRowCount,
  ).also((it) {
    _logger.fine('here1');
  });
});

final _gridDataStreamController = StreamController<GridData>();

final _gridDataProvider = StreamProvider<GridData>((ref) async* {
  final initData = await ref.watch(_initDataProvider.future);
  _logger.fine('here2');
  yield GridData(
    unitShape: UnitShape.square,
    columnCount: initData.defaultColumnCount,
    rowCount: initData.defaultRowCount,
  ).also((it) {
    _logger.fine('here3');
  });
  await for (final data in _gridDataStreamController.stream) {
    yield data;
  }
});

/// ペイントインデックス
final _paintIndexProvider = StateProvider((ref) => 0);

/// 倍率インデックス
final _scaleIndexProvider = StateProvider((ref) => 1);

final _gridDataEditStack = <GridData>[];
final _gridDataUndoStack = <GridData>[];

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
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          ...const MaterialScrollBehavior().dragDevices,
        },
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// 正方形ユニットタイルウィジェット
///
class SquareWidget extends HookConsumerWidget {
  final double size;
  final GridData gridData;
  final int column;
  final int row;

  const SquareWidget({
    super.key,
    required this.size,
    required this.gridData,
    required this.column,
    required this.row,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paintIndex = ref.watch(_paintIndexProvider);
    final unit = gridData.getUnit(column, row);

    Widget buildLandSquare(LandType landType, double size) {
      final builders = <Widget Function(double size)>[
        (size) => Image.asset('assets/images/floor.png', width: size, height: size),
        (size) => Image.asset('assets/images/rock.png', width: size, height: size),
        (size) => Image.asset('assets/images/water.png', width: size, height: size),
        (size) => Icon(Icons.air, size: size),
      ];
      return builders[landType.index](size);
    }

    Widget buildWallSquare(WallType wallType, int direction, double size) {
      final builders = <Widget Function(double size)>[
        (size) => Image.asset('assets/images/wall.png', width: size, height: size),
        (size) => Image.asset('assets/images/path.png', width: size, height: size),
        (size) => Image.asset('assets/images/door.png', width: size, height: size),
      ];
      return Transform.rotate(
        angle: 0.5 * math.pi * direction,
        child: builders[wallType.index](size),
      );
    }

    int getDirection(Offset offset) {
      double angle = math.atan2(offset.dy, offset.dx);
      if (angle >= -0.75 * math.pi && angle < -0.25 * math.pi) {
        return 0;
      } else if (angle >= -0.25 * math.pi && angle < 0.25 * math.pi) {
        return 1;
      } else if (angle >= 0.25 * math.pi && angle < 0.75 * math.pi) {
        return 2;
      } else {
        return 3;
      }
    }

    return GestureDetector(
      onTapUp: (details) {
        _logger.fine('tap up: ${details.localPosition}');
        if (paintIndex < LandType.values.length) {
          // 床
          final newLandType = LandType.values[paintIndex];
          if (unit.landType != newLandType) {
            final newUnitData = unit.copyWith(landType: newLandType);
            final newGridData = gridData.setUnit(column, row, newUnitData);
            _gridDataStreamController.sink.add(newGridData);
          }
        } else {
          // 壁
          final offset = details.localPosition - Offset(size * 0.5, size * 0.5);
          if (offset.dx.abs() >= size * 0.25 || offset.dy.abs() >= size * 0.25) {
            final dir = getDirection(offset);
            final newWallType = WallType.values[paintIndex - LandType.values.length];
            if (newWallType != unit.getWall(dir)) {
              final newGridData = gridData.setUnit(column, row, unit.setWall(dir, newWallType));
              _gridDataStreamController.sink.add(newGridData);
            }
          }
        }
      },
      child: Tooltip(
        message: '($column, $row)',
        child: Stack(
          children: [
            // 床
            buildLandSquare(unit.landType, size),
            // 北、東、南、西
            for (int dir = 0; dir < 4; ++dir) buildWallSquare(unit.getWall(dir), dir, size),
          ],
        ),
      ),
    );
  }
}

/// マップウィジェット
///
class MapWidget extends HookConsumerWidget {
  final GridData gridData;

  const MapWidget({
    super.key,
    required this.gridData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaleIndex = ref.watch(_scaleIndexProvider);
    final size = _squareDimension * _scales[scaleIndex];

    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: (BuildContext context, TableVicinity vicinity) {
        return SquareWidget(
          size: size,
          gridData: gridData,
          column: vicinity.column,
          row: vicinity.row,
        );
      },
      columnCount: gridData.columnCount,
      columnBuilder: (int column) {
        return TableSpan(
          extent: FixedTableSpanExtent(size),
        );
      },
      rowCount: gridData.rowCount,
      rowBuilder: (int row) {
        return TableSpan(
          extent: FixedTableSpanExtent(size),
          backgroundDecoration: const TableSpanDecoration(color: Colors.black38),
        );
      },
    );
  }
}

/// 編集ツールウィジェット
///
class EditToolWidget extends HookConsumerWidget {
  final GridData gridData;

  const EditToolWidget({
    super.key,
    required this.gridData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paintIndex = ref.watch(_paintIndexProvider);
    final scaleIndex = ref.watch(_scaleIndexProvider);

    return Column(
      children: [
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: [
            // 倍率
            IconButton(
              onPressed: (scaleIndex > 0)
                  ? () => ref.read(_scaleIndexProvider.notifier).state = scaleIndex - 1
                  : null,
              icon: const Icon(Icons.zoom_out),
            ),
            IconButton(
              onPressed: (scaleIndex < _scales.length - 1)
                  ? () => ref.read(_scaleIndexProvider.notifier).state = scaleIndex + 1
                  : null,
              icon: const Icon(Icons.zoom_in),
            ),

            // 床
            for (int i = 0; i < LandType.values.length; ++i)
              (i == paintIndex)
                  ? IconButton.outlined(
                      onPressed: () {},
                      icon: Image.asset(
                        _paintImageAssets[i],
                        width: 24,
                        height: 24,
                      ),
                    )
                  : IconButton(
                      onPressed: () => ref.read(_paintIndexProvider.notifier).state = i,
                      icon: Image.asset(
                        _paintImageAssets[i],
                        width: 24,
                        height: 24,
                      ),
                    ),
            // 壁
            for (int i = 0; i < WallType.values.length; ++i)
              ((i + LandType.values.length) == paintIndex)
                  ? IconButton.outlined(
                      onPressed: () {},
                      icon: Transform.translate(
                        offset: const Offset(0, 11),
                        child: Image.asset(
                          _paintImageAssets[i + LandType.values.length],
                          width: 24,
                          height: 24,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () =>
                          ref.read(_paintIndexProvider.notifier).state = i + LandType.values.length,
                      icon: Transform.translate(
                        offset: const Offset(0, 11),
                        child: Image.asset(
                          _paintImageAssets[i + LandType.values.length],
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
          ],
        ),
      ],
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridData = ref.watch(_gridDataProvider);

    return Scaffold(
      body: gridData.when(
        data: (data) => Row(
          children: [
            SizedBox(
              width: 84.0,
              child: EditToolWidget(gridData: data),
            ),
            Expanded(child: MapWidget(gridData: data)),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text(error.toString()),
      ),
    );
  }
}
