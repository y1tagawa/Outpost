// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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
    // todo:隠す
    final url = Uri.parse('http://cf588074.cloudfree.jp/api.php?jiscolor=all');
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
    for (final r1 in value) {
      final row = r1 as Map<String, dynamic>;
      final rgb = row['rgb']! as String;
      final name = row['name']! as String;
      Logger().d('$rgb $name ${int.parse('0xFF$rgb')}');
      result.add(_JisColor(name: name, color: Color(int.parse('0xFF$rgb'))));
    }
    Logger().d('${result.length}');
    return result;
  },
);

void main() {
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

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(colorsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: colors.when(
          data: (data) {
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(data.length.toString()),
                Text('here!'),
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
