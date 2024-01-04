// Copyright 2024 Yoshinori Tagawa. All rights reserved.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter_scroll_view/grid_data.dart';
import 'package:hello_flutter_scroll_view/scope_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

final _logger = Logger('hello_flutter_two_dimensional');

class _InitData {
  final List<String> defaultFloorTypeNames;
  final List<String> defaultWallTypeNames;

  const _InitData({
    required this.defaultFloorTypeNames,
    required this.defaultWallTypeNames,
  });
}

final _initDataProvider = FutureProvider((ref) async {
  final json = jsonDecode(
    await rootBundle.loadString('assets/init_data.json'),
  ) as Map<String, Object?>;

  final defaultFloorTypeNames = (json['default_floor_type_names']! as List<Object?>).let((it) {
    assert(it.length >= 8);
    return List.generate(it.length, (i) => it[i] as String);
  });

  final defaultWallTypeNames = (json['default_wall_type_names']! as List<Object?>).let((it) {
    assert(it.length >= 8);
    return List.generate(it.length, (i) => it[i] as String);
  });

  return _InitData(
    defaultFloorTypeNames: defaultFloorTypeNames,
    defaultWallTypeNames: defaultWallTypeNames,
  );
});

final _gridDataEditStack = <GridData>[];
final _gridDataUndoStack = <GridData>[];

final _gridDataStreamController = StreamController<GridData>();

final _gridDataProvider = StreamProvider((ref) async* {
  await for (final data in _gridDataStreamController.stream) {
    yield data;
  }
});

void main() {
  Logger.root.level = Level.INFO;
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
    final initData = ref.watch(_initDataProvider);
    return Scaffold(
      body: initData.when(
        data: (data) => TableView.builder(
          cellBuilder: (BuildContext context, TableVicinity vicinity) {
            _logger.fine(initData.value?.defaultFloorTypeNames);
            return Center(
              child: Text('Cell ${vicinity.column} : ${vicinity.row}'),
            );
          },
          columnCount: 10,
          columnBuilder: (int column) {
            return const TableSpan(
              extent: FixedTableSpanExtent(100),
              foregroundDecoration: TableSpanDecoration(
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
          rowCount: 10,
          rowBuilder: (int row) {
            return TableSpan(
              extent: const FixedTableSpanExtent(100),
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
