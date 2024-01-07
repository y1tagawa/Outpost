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

final _logger = Logger('hello_flutter_two_dimensional');

class _InitData {
  final int defaultColumnCount;
  final int defaultRowCount;
  final List<String> defaultFloorTypeNames;
  final List<String> defaultWallTypeNames;

  const _InitData({
    required this.defaultColumnCount,
    required this.defaultRowCount,
    required this.defaultFloorTypeNames,
    required this.defaultWallTypeNames,
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

  final defaultFloorTypeNames = (json['default_floor_type_names']! as List<Object?>).let((it) {
    assert(it.length >= 8);
    return List.generate(it.length, (i) => it[i] as String);
  });

  final defaultWallTypeNames = (json['default_wall_type_names']! as List<Object?>).let((it) {
    assert(it.length >= 8);
    return List.generate(it.length, (i) => it[i] as String);
  });

  return _InitData(
    defaultColumnCount: defaultColumnCount,
    defaultRowCount: defaultRowCount,
    defaultFloorTypeNames: defaultFloorTypeNames,
    defaultWallTypeNames: defaultWallTypeNames,
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
    floorTypeNames: initData.defaultFloorTypeNames,
    wallTypeNames: initData.defaultWallTypeNames,
  ).also((it) {
    _logger.fine('here3');
  });
  await for (final data in _gridDataStreamController.stream) {
    yield data;
  }
});

final _scaleProvider = StateProvider((ref) => 1);

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

class SquareWidget extends HookConsumerWidget {
  final double dimension;
  final int column;
  final int row;
  final void Function()? onWheelUp;
  final void Function()? onWheelDown;
  const SquareWidget({
    super.key,
    required this.dimension,
    required this.column,
    required this.row,
    this.onWheelUp,
    this.onWheelDown,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _logger.fine('scroll ${event.localPosition} ${event.scrollDelta}');
          if (event.scrollDelta.dy > 0.0) {
            onWheelDown?.call();
          } else if (event.scrollDelta.dy < 0.0) {
            onWheelUp?.call();
          }
          GestureBinding.instance.pointerSignalResolver.register(
            event,
            (PointerSignalEvent _) {}, // do nothing to stop wheel scroll
          );
        }
      },
      child: GestureDetector(
        onTapUp: (details) {
          _logger.fine('tap up ${details.localPosition}');
        },
        onSecondaryTap: () {
          _logger.fine('secondary tap');
        },
        child: SizedBox.square(
          dimension: dimension,
          child: Center(child: Text('$column, $row')),
        ),
      ),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const scaleToDimension = [25.0, 50.0, 75.0, 100.0];
    final gridData = ref.watch(_gridDataProvider);
    final scale = ref.watch(_scaleProvider);
    final dimension = scaleToDimension[scale];

    return Scaffold(
      body: gridData.when(
        data: (data) => TableView.builder(
          diagonalDragBehavior: DiagonalDragBehavior.free,
          cellBuilder: (BuildContext context, TableVicinity vicinity) {
            return SquareWidget(
              dimension: dimension,
              column: vicinity.column,
              row: vicinity.row,
              onWheelDown: () {
                ref.read(_scaleProvider.notifier).state = math.min(scale + 1, 2);
              },
              onWheelUp: () {
                ref.read(_scaleProvider.notifier).state = math.max(scale - 1, 0);
              },
            );
          },
          columnCount: gridData.value!.columnCount,
          columnBuilder: (int column) {
            return TableSpan(
              extent: FixedTableSpanExtent(dimension),
              foregroundDecoration: const TableSpanDecoration(
                border: TableSpanBorder(
                  trailing: BorderSide(
                    color: Colors.black,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            );
          },
          rowCount: gridData.value!.rowCount,
          rowBuilder: (int row) {
            return TableSpan(
              extent: FixedTableSpanExtent(dimension),
              backgroundDecoration: TableSpanDecoration(
                color: row.isEven ? Colors.blueAccent[100] : Colors.white,
              ),
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text(error.toString()),
      ),
    );
  }
}
