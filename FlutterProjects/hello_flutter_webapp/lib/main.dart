// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'api_url.dart';

final logger = Logger('hello_flutter_webapp');

// サーバAPIを使用して、JIS慣用色名データを取得する。

class _JisColor {
  final String name;
  final Color color;

  const _JisColor({
    required this.name,
    required this.color,
  });
}

final colorsProvider = FutureProvider<List<_JisColor>>(
  (ref) async {
    final url = Uri.parse(apiUrl);
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('http status error: ${response.statusCode}');
    }
    final map = json.decode(response.body) as Map<String, dynamic>;
    if (map['status']! != 'ok') {
      throw HttpException('bad response: $map');
    }
    final value = map['value']! as List<dynamic>;
    final result = <_JisColor>[];
    for (final Map<String, dynamic> row in value) {
      final rgb = row['rgb']! as String;
      final name = row['name']! as String;
      result.add(_JisColor(name: name, color: Color(int.parse('0xFF$rgb'))));
    }
    return result;
  },
);

// メイン

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
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Hello Flutter Web App'),
    );
  }
}

// APIで取得したデータを表示する。

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(colorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: colors.when(
          data: (data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('JIS慣用色名'),
                Expanded(
                  child: ListView(
                    itemExtent: 48,
                    children: [
                      for (final item in data)
                        ListTile(
                          leading: SizedBox(
                            width: 32,
                            height: 32,
                            child: ColoredBox(
                              color: item.color,
                            ),
                          ),
                          title: Text(item.name),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
