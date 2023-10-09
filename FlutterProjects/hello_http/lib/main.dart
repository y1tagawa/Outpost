// Copyright 2023 Yoshinori Tagawa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final _queue = StreamController<http.Response>();

final _eventProvider = StreamProvider<http.Response>((ref) => _queue.stream);

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Http demo'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(_eventProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: data.when(
          data: (data) => Column(
            children: [
              // Text('time=${data.time.toLocal().toString()}'),
              // Text('status code=${data.response.statusCode}'),
              // Text('body=${data.response.body}'),
              Text(data.statusCode.toString()),
            ],
          ),
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: refreshEnabled ? null : Theme.of(context).disabledColor,
        onPressed: () async {
          final url = Uri.https('373news.com', '_info/shiomi/1/');
          try {
            final response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
            print('Response status: ${response.statusCode}');
            _queue.add(response);
          } catch (e) {
            print(e.toString());
          }
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
