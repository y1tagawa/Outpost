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

class _ResponseAndTime {
  http.Response response;
  DateTime time;
  _ResponseAndTime({
    required this.response,
    required this.time,
  });
}

final _responseAndTimeProvider = StateProvider<_ResponseAndTime?>((ref) => null);

final _futureProvider = FutureProvider.autoDispose<_ResponseAndTime>(
  (ref) async {
    final logger = Logger('_futureProvider');

    // 一時的に更新・再試行を抑制する。
    ref.read(_refreshEnabledProvider.notifier).state = false;

    final url = Uri.https('github.com', 'y1tagawa/Outpost');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 30));
      // 成功した場合、一定時間後に更新可能にする。
      Timer(const Duration(seconds: 30), () {
        logger.fine('enabling refresh button');
        ref.read(_refreshEnabledProvider.notifier).state = true;
      });
      return _ResponseAndTime(response: response, time: DateTime.now());
    } on Exception catch (_) {
      // タイムアウトまたは他のエラーが発生した場合も、一定時間後に再試行可能にする。
      Timer(const Duration(seconds: 30), () {
        logger.fine('enabling refresh button');
        ref.read(_refreshEnabledProvider.notifier).state = true;
      });
      rethrow;
    }
  },
);

// 更新ボタン有効状態（連打・DOS対策）
final _refreshEnabledProvider = StateProvider((ref) => true);

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

    final responseAndTime = ref.watch(_responseAndTimeProvider);
    final refreshEnabled = ref.watch(_refreshEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: data.when(
          data: (data) => Column(
            children: [
              Text('time=${data.time.toLocal().toString()}'),
              Text('status code=${data.response.statusCode}'),
              Text('body=${data.response.body}'),
            ],
          ),
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: refreshEnabled ? null : Theme.of(context).disabledColor,
        onPressed: () async {
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
