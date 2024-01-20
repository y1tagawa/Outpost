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
/// 300~399, 400~499...599 少数属性値
final _editToolIndexProvider = StateProvider((ref) => _minLandToolIndex);
const _minLandToolIndex = 0;
const _minWallToolIndex = 100;
const _minMarkToolIndex = 200;
const _minTitbitToolIndex = 300;

final _landToolIndexProvider = StateProvider((ref) => _minLandToolIndex);
final _wallToolIndexProvider = StateProvider((ref) => _minWallToolIndex);
final _markToolIndexProvider = StateProvider((ref) => _minMarkToolIndex);

final _visibleTitbitLayerProvider = StateProvider((ref) => -1); // -1:非表示
final _titbitToolAlphaProvider = StateProvider((ref) => 0);

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

///
class _LandSquare extends StatelessWidget {
  static const _icons = [
    (Icons.square_outlined, Colors.grey),
    (Icons.broken_image, Colors.black),
    (Icons.water, Colors.black),
    (Icons.air, Colors.black),
  ];

  final LandType landType;
  final double size;

  const _LandSquare({super.key, required this.landType, required this.size});

  @override
  Widget build(BuildContext context) {
    final icon = _icons[landType.index];
    return Icon(icon.$1, color: icon.$2, size: size);
  }
}

///
class _WallSquare extends StatelessWidget {
  static const _assets = [
    'assets/images/path.png',
    'assets/images/wall.png',
    'assets/images/door.png',
  ];

  final WallType wallType;
  final int dir;
  final double size;

  const _WallSquare({
    super.key,
    required this.wallType,
    required this.dir,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.5 * math.pi * dir,
      child: Image.asset(
        _assets[wallType.index],
        width: size,
        height: size,
      ),
    );
  }
}

///
class _MarkSquare extends StatelessWidget {
  static const _assets = [
    'assets/images/mark_none.png',
    'assets/images/mark1.png',
    'assets/images/mark2.png',
    'assets/images/mark3.png',
    'assets/images/mark4.png',
    'assets/images/mark5.png',
    'assets/images/mark6.png',
    'assets/images/mark7.png',
    'assets/images/mark8.png',
    'assets/images/mark9.png',
  ];

  final Mark mark;
  final double size;
  final double iconSize;

  const _MarkSquare({
    super.key,
    required this.mark,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: Image.asset(_assets[mark.index], width: iconSize, height: iconSize),
      ),
    );
  }
}

///
class _TitbitSquare extends StatelessWidget {
  static const _alphas = [0x00, 0x30, 0x60, 0xA0];
  static const _colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

  final Titbit titbit;
  final int index;
  final double size;

  const _TitbitSquare({
    super.key,
    required this.titbit,
    required this.index,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (titbit == Titbit.none) {
      return SizedBox.square(dimension: size);
    } else {
      return ColoredBox(
        color: _colors[index].withAlpha(_alphas[titbit.index]),
        child: SizedBox.square(dimension: size),
      );
    }
  }
}

/// 正方形単位図形ウィジェット
///
class _SquareWidget extends HookConsumerWidget {
  final double size;
  final GridData gridData;
  final int column;
  final int row;
  final int toolIndex;
  final int visibleTitbitLayer;

  const _SquareWidget({
    super.key,
    required this.size,
    required this.gridData,
    required this.column,
    required this.row,
    required this.toolIndex,
    required this.visibleTitbitLayer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tile = gridData.getTile(column, row);
    final markSize = math.min(size * 0.4, 20.0);

    Widget buildWallMark(Mark mark, int dir, double size) {
      final offsets = [
        Offset(0, size * -0.25),
        Offset(size * 0.25, 0),
        Offset(0, size * 0.25),
        Offset(size * -0.25, 0),
      ];
      return Transform.translate(
        offset: offsets[dir],
        child: _MarkSquare(mark: mark, size: size, iconSize: markSize),
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
        if (toolIndex < _minWallToolIndex) {
          // 床
          final newLandType = LandType.values[toolIndex];
          if (tile.landType != newLandType) {
            final newTileData = tile.copyWith(landType: newLandType);
            final newGridData = gridData.copyWithTile(column, row, newTileData);
            _gridDataStreamController.sink.add(newGridData);
          }
        } else if (toolIndex < _minMarkToolIndex) {
          // 壁
          final offset = details.localPosition - Offset(size * 0.5, size * 0.5);
          if (offset.dx.abs() >= size * 0.25 || offset.dy.abs() >= size * 0.25) {
            final dir = getDirection(offset);
            final newWallType = WallType.values[toolIndex - _minWallToolIndex];
            if (newWallType != tile.getWallType(dir)) {
              final newGridData = gridData.copyWithWallTypeBothSides(column, row, dir, newWallType);
              _gridDataStreamController.sink.add(newGridData);
            }
          }
        } else if (toolIndex < _minTitbitToolIndex) {
          // マーク
          final newMark = Mark.values[toolIndex - _minMarkToolIndex];
          final offset = details.localPosition - Offset(size * 0.5, size * 0.5);
          if (offset.dx.abs() >= size * 0.25 || offset.dy.abs() >= size * 0.25) {
            // 壁マーク
            final dir = getDirection(offset);
            if (newMark != tile.getWallMark(dir)) {
              final newGridData =
                  gridData.copyWithTile(column, row, tile.copyWithWallMark(dir, newMark));
              _gridDataStreamController.sink.add(newGridData);
            }
          } else {
            // 床マーク
            if (newMark != tile.landMark) {
              final newGridData =
                  gridData.copyWithTile(column, row, tile.copyWith(landMark: newMark));
              _gridDataStreamController.sink.add(newGridData);
            }
          }
        } else {
          // titbit
          final index = (toolIndex - _minTitbitToolIndex) ~/ 100;
          final newTitbit = Titbit.values[(toolIndex - _minTitbitToolIndex) % 100];
          if (newTitbit != tile.getTitbit(index)) {
            final newGridData =
                gridData.copyWithTile(column, row, tile.copyWithTitbit(index, newTitbit));
            _gridDataStreamController.sink.add(newGridData);
          }
        }
      },
      child: Stack(
        children: [
          // 床
          if (tile.landType == LandType.floor)
            SizedBox.square(dimension: size)
          else
            _LandSquare(landType: tile.landType, size: size),
          // titbits
          if (visibleTitbitLayer >= 0 && tile.getTitbit(visibleTitbitLayer) != Titbit.none)
            _TitbitSquare(
                titbit: tile.getTitbit(visibleTitbitLayer), index: visibleTitbitLayer, size: size),
          // 北、東、南、西
          for (int dir = 0; dir < 4; ++dir)
            _WallSquare(wallType: tile.getWallType(dir), dir: dir, size: size),
          // 床マーク
          if (tile.landMark != Mark.none)
            _MarkSquare(mark: tile.landMark, size: size, iconSize: markSize),
          // 壁マーク
          for (int dir = 0; dir < 4; ++dir)
            if (tile.getWallMark(dir) != Mark.none) buildWallMark(tile.getWallMark(dir), dir, size),
        ],
      ),
    );
  }
}

/// マップウィジェット
///
class _GridWidget extends HookConsumerWidget {
  final GridData gridData;

  const _GridWidget({
    super.key,
    required this.gridData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaleIndex = ref.watch(_scaleIndexProvider);
    final size = _squareDimension * _scales[scaleIndex];
    final toolIndex = ref.watch(_editToolIndexProvider);
    final visibleTitbitLayer = ref.watch(_visibleTitbitLayerProvider);

    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: (BuildContext context, TableVicinity vicinity) {
        return _SquareWidget(
          size: size,
          gridData: gridData,
          column: vicinity.column,
          row: vicinity.row,
          toolIndex: toolIndex,
          visibleTitbitLayer: visibleTitbitLayer,
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
          backgroundDecoration: const TableSpanDecoration(color: Color(0xFFB3B3B3)),
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
    final editToolIndex = ref.watch(_editToolIndexProvider);
    final scaleIndex = ref.watch(_scaleIndexProvider);
    final visibleTitbitLayer = ref.watch(_visibleTitbitLayerProvider);

    Widget buildWallIcon(WallType wallType) {
      return Transform.translate(
        offset: const Offset(-21, 0),
        child: Transform.scale(
          scaleX: 2.0,
          child: _WallSquare(wallType: wallType, dir: 1, size: 24),
        ),
      );
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
              onPressed: () async {
                final json = await rootBundle.loadString('assets/test.json');
                final map = jsonDecode(json) as Map<String, Object?>;
                final data = GridData.fromMap(map);
                print(data);
                _gridDataStreamController.sink.add(data);
              },
              icon: const Icon(Icons.file_open_outlined),
              tooltip: 'open',
            ),
            IconButton(
              onPressed: () {
                final map = gridData.toMap();
                print(jsonEncode(map));
              },
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

        Wrap(
          children: [
            // 床
            ColoredBox(
              color: editToolIndex >= _minLandToolIndex && editToolIndex < _minWallToolIndex
                  ? Colors.black12
                  : Colors.transparent,
              child: DropdownButton(
                value: ref.watch(_landToolIndexProvider),
                items: [
                  for (int i = 0; i < LandType.values.length; ++i)
                    DropdownMenuItem(
                      value: i,
                      child: _LandSquare(landType: LandType.values[i], size: 24),
                    ),
                ],
                onChanged: (value) {
                  ref.read(_landToolIndexProvider.notifier).state =
                      ref.read(_editToolIndexProvider.notifier).state = value!;
                },
              ),
            ),

            // 壁
            ColoredBox(
              color: editToolIndex >= _minWallToolIndex && editToolIndex < _minMarkToolIndex
                  ? Colors.black12
                  : Colors.transparent,
              child: DropdownButton(
                value: ref.watch(_wallToolIndexProvider),
                items: [
                  for (int i = 0; i < WallType.values.length; ++i)
                    DropdownMenuItem(
                      value: i + _minWallToolIndex,
                      child: buildWallIcon(WallType.values[i]),
                    ),
                ],
                onChanged: (value) {
                  ref.read(_wallToolIndexProvider.notifier).state =
                      ref.read(_editToolIndexProvider.notifier).state = value!;
                },
              ),
            ),

            // マーク
            ColoredBox(
              color: editToolIndex >= _minMarkToolIndex && editToolIndex < _minTitbitToolIndex
                  ? Colors.black12
                  : Colors.transparent,
              child: DropdownButton(
                value: ref.watch(_markToolIndexProvider),
                items: [
                  for (int i = 0; i < Mark.values.length; ++i)
                    DropdownMenuItem(
                      value: i + _minMarkToolIndex,
                      child: _MarkSquare(mark: Mark.values[i], size: 24, iconSize: 20),
                    ),
                ],
                onChanged: (value) {
                  ref.read(_markToolIndexProvider.notifier).state =
                      ref.read(_editToolIndexProvider.notifier).state = value!;
                },
              ),
            ),
          ],
        ),

        // titbits
        Wrap(
          children: [
            // titbit表示レイヤー
            DropdownButton(
              value: visibleTitbitLayer,
              items: [
                // 非表示
                const DropdownMenuItem(
                  value: -1,
                  child: _TitbitSquare(titbit: Titbit.none, index: 0, size: 24),
                ),
                // 表示レイヤー
                for (int i = 0; i < TileData.titbitCount; ++i)
                  DropdownMenuItem(
                    value: i,
                    child: _TitbitSquare(titbit: Titbit.v2, index: i, size: 24),
                  )
              ],
              onChanged: (value) {
                ref.read(_visibleTitbitLayerProvider.notifier).state = value!;
              },
            ),

            if (visibleTitbitLayer >= 0)
              DropdownButton(
                value: ref.watch(_titbitToolAlphaProvider),
                items: [
                  for (int j = 0; j < Titbit.values.length; ++j)
                    DropdownMenuItem(
                      value: j,
                      child: _TitbitSquare(
                          titbit: Titbit.values[j], index: visibleTitbitLayer, size: 24),
                    ),
                ],
                onChanged: (value) {
                  ref.read(_titbitToolAlphaProvider.notifier).state = value!;
                  final toolIndex = visibleTitbitLayer * 100 + _minTitbitToolIndex + value;
                  ref.read(_editToolIndexProvider.notifier).state = toolIndex;
                },
              ),
          ],
        )
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
            Expanded(child: _GridWidget(gridData: data)),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text(error.toString()),
      ),
    );
  }
}
