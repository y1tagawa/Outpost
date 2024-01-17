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
const _scales = [0.25, 0.3535534, 0.5];

Widget _buildLandSquare(LandType landType, double size) {
  final builders = <Widget Function(double size)>[
    (size) => Image.asset('assets/images/floor.png', width: size, height: size),
    (size) => Icon(Icons.broken_image, size: size),
    (size) => Icon(Icons.water, size: size),
    (size) => Icon(Icons.air, size: size),
  ];
  return builders[landType.index](size);
}

Widget _buildWallSquare(WallType wallType, int dir, double size) {
  final builders = <Widget Function(double size)>[
    (size) => Image.asset('assets/images/path.png', width: size, height: size),
    (size) => Image.asset('assets/images/wall.png', width: size, height: size),
    (size) => Image.asset('assets/images/door.png', width: size, height: size),
  ];
  return Transform.rotate(
    angle: 0.5 * math.pi * dir,
    child: builders[wallType.index](size),
  );
}

Widget _buildMarkSquare(MarkType markType, double size, double iconSize) {
  final builders = <Widget Function(double size)>[
    (size) => Image.asset('assets/images/mark_none.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark1.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark2.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark3.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark4.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark5.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark6.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark7.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark8.png', width: size, height: size),
    (size) => Image.asset('assets/images/mark9.png', width: size, height: size),
  ];
  return SizedBox.square(
    dimension: size,
    child: Center(child: builders[markType.index](iconSize)),
  );
}

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
  final columnCount = initData.defaultColumnCount;
  final rowCount = initData.defaultRowCount;
  final wallTypes = List.generate(TileData.dirCount, (_) => WallType.wall);
  yield GridData(
    tileShape: TileShape.square,
    columnCount: columnCount,
    rowCount: rowCount,
    tiles: List.generate(columnCount * rowCount, (_) => TileData(wallTypes: wallTypes)),
  ).also((it) {
    _logger.fine('here3');
  });
  await for (final data in _gridDataStreamController.stream) {
    yield data;
  }
});

/// 編集ツールインデックス
/// 0~99 床
/// 100~199 壁
/// 200~299 マーク
final _toolIndexProvider = StateProvider((ref) => 0);
const _minWallToolIndex = 100;
const _minMarkToolIndex = 200;

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
    final toolIndex = ref.watch(_toolIndexProvider);
    final tile = gridData.getTile(column, row);

    final markSize = math.min(size * 0.4, 20.0);

    Widget buildWallMark(MarkType markType, int dir, double size) {
      final offsets = [
        Offset(0, size * -0.25),
        Offset(size * 0.25, 0),
        Offset(0, size * 0.25),
        Offset(size * -0.25, 0),
      ];
      return Transform.translate(
        offset: offsets[dir],
        child: _buildMarkSquare(markType, size, markSize),
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
        if (toolIndex < _minWallToolIndex) {
          // 床
          final newLandType = LandType.values[toolIndex];
          if (tile.landType != newLandType) {
            final newTileData = tile.copyWith(landType: newLandType);
            final newGridData = gridData.setTile(column, row, newTileData);
            _gridDataStreamController.sink.add(newGridData);
          }
        } else if (toolIndex < _minMarkToolIndex) {
          // 壁
          final offset = details.localPosition - Offset(size * 0.5, size * 0.5);
          if (offset.dx.abs() >= size * 0.25 || offset.dy.abs() >= size * 0.25) {
            final dir = getDirection(offset);
            final newWallType = WallType.values[toolIndex - _minWallToolIndex];
            if (newWallType != tile.getWallType(dir)) {
              final newGridData = gridData.setWallTypes(column, row, dir, newWallType);
              _gridDataStreamController.sink.add(newGridData);
            }
          }
        } else {
          // マーク
          final newMarkType = MarkType.values[toolIndex - _minMarkToolIndex];
          final offset = details.localPosition - Offset(size * 0.5, size * 0.5);
          if (offset.dx.abs() >= size * 0.25 || offset.dy.abs() >= size * 0.25) {
            // 壁マーク
            final dir = getDirection(offset);
            if (newMarkType != tile.getWallMarkType(dir)) {
              final newGridData =
                  gridData.setTile(column, row, tile.setWallMarkType(dir, newMarkType));
              _gridDataStreamController.sink.add(newGridData);
            }
          } else {
            // 床マーク
            if (newMarkType != tile.landMarkType) {
              final newGridData =
                  gridData.setTile(column, row, tile.copyWith(landMarkType: newMarkType));
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
            _buildLandSquare(tile.landType, size),
            // 北、東、南、西
            for (int dir = 0; dir < 4; ++dir) _buildWallSquare(tile.getWallType(dir), dir, size),
            // 床マーク
            if (tile.landMarkType != MarkType.none)
              _buildMarkSquare(tile.landMarkType, size, markSize),
            // 壁マーク
            for (int dir = 0; dir < 4; ++dir)
              if (tile.getWallMarkType(dir) != MarkType.none)
                buildWallMark(tile.getWallMarkType(dir), dir, size),
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
    final toolIndex = ref.watch(_toolIndexProvider);
    final scaleIndex = ref.watch(_scaleIndexProvider);

    Widget buildWallIcon(WallType wallType) {
      return Transform.translate(
        offset: const Offset(-21, 0),
        child: Transform.scale(
          scaleX: 2.0,
          child: _buildWallSquare(wallType, 1, 24),
        ),
      );
    }

    Widget buildIconButton({
      required bool outlined,
      void Function()? onPressed,
      String? tooltip,
      required Widget icon,
    }) {
      if (outlined) {
        return IconButton.outlined(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltip,
        );
      } else {
        return IconButton(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltip,
        );
      }
    }

    return Column(
      children: [
        Wrap(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.insert_drive_file_outlined),
              tooltip: 'new',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.file_open_outlined),
              tooltip: 'open',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.task_outlined),
              tooltip: 'save',
            ),
          ],
        ),

        // 倍率
        Wrap(
          children: [
            IconButton(
              onPressed: (scaleIndex > 0)
                  ? () => ref.read(_scaleIndexProvider.notifier).state = scaleIndex - 1
                  : null,
              icon: const Icon(Icons.zoom_out),
              tooltip: 'zoom out',
            ),
            IconButton(
              onPressed: (scaleIndex < _scales.length - 1)
                  ? () => ref.read(_scaleIndexProvider.notifier).state = scaleIndex + 1
                  : null,
              icon: const Icon(Icons.zoom_in),
              tooltip: 'zoom in',
            ),
          ],
        ),

        // 床
        Wrap(
          children: [
            for (int i = 0; i < LandType.values.length; ++i)
              buildIconButton(
                outlined: (i == toolIndex),
                onPressed: () => ref.read(_toolIndexProvider.notifier).state = i,
                icon: _buildLandSquare(LandType.values[i], 24),
                tooltip: LandType.values[i].name,
              ),
          ],
        ),

        // 壁
        Wrap(
          children: [
            for (int i = 0; i < WallType.values.length; ++i)
              buildIconButton(
                outlined: (i + _minWallToolIndex == toolIndex),
                onPressed: () =>
                    ref.read(_toolIndexProvider.notifier).state = i + _minWallToolIndex,
                icon: buildWallIcon(WallType.values[i]),
                tooltip: WallType.values[i].name,
              ),
          ],
        ),

        // マーク
        Wrap(
          children: [
            for (int i = 0; i < MarkType.values.length; ++i)
              buildIconButton(
                outlined: (i + _minMarkToolIndex == toolIndex),
                onPressed: () =>
                    ref.read(_toolIndexProvider.notifier).state = i + _minMarkToolIndex,
                icon: _buildMarkSquare(MarkType.values[i], 24, 20),
                tooltip: MarkType.values[i].name,
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
              width: 168.0,
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
