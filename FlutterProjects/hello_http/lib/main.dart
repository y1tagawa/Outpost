// Copyright 2023 Yoshinori Tagawa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:hello_http/scope_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class _Data {
  Object value;
  DateTime time;
  _Data({
    required this.value,
    required this.time,
  });
}

final _futureProvider = FutureProvider.autoDispose<_Data>(
  (ref) async {
    final logger = Logger('_futureProvider');

    final url = Uri.https('github.com', 'y1tagawa/Outpost');
    try {
      logger.fine('calling get');
      final response = await http.get(url).timeout(const Duration(seconds: 30));
      logger.fine('get succeeded');
      Timer(const Duration(seconds: 30), () {
        logger.fine('enabling refresh button');
        ref.read(_refreshableProvider.notifier).state = true;
      });
      return _Data(value: response.toString(), time: DateTime.now());
    } on TimeoutException catch (e) {
      // timeout
      Timer(const Duration(seconds: 30), () {
        logger.fine('enabling refresh button');
        ref.read(_refreshableProvider.notifier).state = true;
      });
      return _Data(value: 'timeout', time: DateTime.now());
    }
  },
);

// 更新ボタン有効状態（連打・DOS対策）
final _refreshableProvider = StateProvider((ref) => false);

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  static final _logger = Logger('MyApp');

  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.fine('[i] build');

    return MaterialApp(
      title: 'Http demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Http demo'),
    ).also((_) {
      _logger.fine('[o] build');
    });
  }
}

class MyHomePage extends ConsumerWidget {
  static final _logger = Logger('MyHomePage');

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.fine('[i] build');

    final data = ref.watch(_futureProvider);
    final refreshable = ref.watch(_refreshableProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: data.when(
          data: (data) => Text(data.value.toString()),
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: refreshable ? null : Theme.of(context).disabledColor,
        onPressed: () async {
          ref.read(_refreshableProvider.notifier).state = false;
          final t = ref.refresh(_futureProvider);
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    ).also((_) {
      _logger.fine('[o] build');
    });
  }
}
