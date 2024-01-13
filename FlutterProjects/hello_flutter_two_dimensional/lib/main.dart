// Copyright 2024 Yoshinori Tagawa. All rights reserved.

import 'dart:async';
import 'dart:convert';

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
  final double dimension;
  final GridData gridData;
  final int column;
  final int row;

  const SquareWidget({
    super.key,
    required this.dimension,
    required this.gridData,
    required this.column,
    required this.row,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paintIndex = ref.watch(_paintIndexProvider);
    final unit = gridData.unitAt(column, row);
    final floorType = unit.floorType;

    return GestureDetector(
      onTap: () {
        if (floorType.index != paintIndex) {
          final newGridData =
              gridData.setUnit(column, row, unit.copyWith(floorType: FloorType.values[paintIndex]));
          _gridDataStreamController.sink.add(newGridData);
        }
      },
      child: Tooltip(
        message: '($column, $row)',
        child: Image.asset(
          _paintImageAssets[floorType.index],
          width: dimension,
          height: dimension,
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
    final dimension = _squareDimension * _scales[scaleIndex];

    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: (BuildContext context, TableVicinity vicinity) {
        return SquareWidget(
          dimension: dimension,
          gridData: gridData,
          column: vicinity.column,
          row: vicinity.row,
        );
      },
      columnCount: gridData.columnCount,
      columnBuilder: (int column) {
        return TableSpan(
          extent: FixedTableSpanExtent(dimension),
          foregroundDecoration: const TableSpanDecoration(
            border: TableSpanBorder(
              trailing: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
              leading: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        );
      },
      rowCount: gridData.rowCount,
      rowBuilder: (int row) {
        return TableSpan(
          extent: FixedTableSpanExtent(dimension),
          foregroundDecoration: const TableSpanDecoration(
            border: TableSpanBorder(
              trailing: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
              leading: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
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
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.insert_drive_file_outlined),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.file_open_outlined),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.task_outlined),
            // ),
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

            // ペイントツール
            for (int i = 0; i < 2; ++i)
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
