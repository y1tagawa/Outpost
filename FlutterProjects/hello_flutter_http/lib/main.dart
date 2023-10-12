// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// サーバレスポンスを非同期に受け付けるキュー
final _queue = StreamController<http.Response>();

final _responseProvider = StreamProvider<http.Response>((ref) => _queue.stream);

// サーバへのリクエスト許可
final _refreshEnabledProvider = StateProvider<bool>((ref) => false);

// メイン
void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Hello Flutter HTTP'),
    );
  }
}

class MyHomePage extends StatefulHookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  /// サーバよりHTMLをゲットする。
  ///
  void _fetch() async {
    final url = Uri.https('373news.com', '_info/shiomi/1/');
    try {
      // 一度リクエストしたら一分後までディセーブルする。
      ref.watch(_refreshEnabledProvider.notifier).state = false;
      Logger().i('disable refreshing');
      Future.delayed(const Duration(seconds: 60), () {
        Logger().i('enable refreshing');
        ref.watch(_refreshEnabledProvider.notifier).state = true;
      });
      // ゲットしてキューに送るとプロバイダがリビルドしてくれる。
      final response = await http.get(url);
      Logger().i('response status: ${response.statusCode}');
      _queue.add(response);
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Logger().i('initial fetch');
    // 起動直後に一回ゲット。
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(_responseProvider);
    final refreshEnabled = ref.watch(_refreshEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: data.when(
          data: (data) {
            if (data.statusCode != 200) {
              return Text('HTTPエラー: ${data.statusCode}');
            } else {
              try {
                final document = html.parse(data.body);
                final tideTableToday = document.getElementById('tide-table-today');
                final ymdw = tideTableToday!.getElementsByClassName('ymdw')[0].text.trim();
                final level = tideTableToday.getElementsByClassName('level')[0].text.trim();
                final age = tideTableToday.getElementsByClassName('age')[0].text.trim();
                return Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(ymdw),
                    Text(level),
                    Text(age),
                  ],
                );
              } catch (e) {
                return Text('HTMLパースエラー: ${e.toString()}');
              }
            }
          },
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: refreshEnabled ? null : Theme.of(context).disabledColor,
        onPressed: refreshEnabled ? _fetch : null,
        tooltip: 'Update',
        child: Icon(refreshEnabled ? Icons.update : Icons.update_disabled),
      ),
    );
  }
}
