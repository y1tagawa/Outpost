// Copyright 2024 Yoshinori Tagawa. All rights reserved.

/// クライアント・サーバ・フレームワークのサンプル
///
/// todo: isolateによるモーダルなセッションのサンプル（JKP, AMHとか）

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'cs_counter.dart';
import 'jkp_amh.dart';

final logger = Logger('hello_flutter_client_server');

const _isCounter = false;

void main() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const MyApp());
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
      home: _isCounter
          ? CsCounterClient(title: 'Flutter Demo Home Page')
          : JkpAmhClient(title: 'Flutter Demo Home Page'),
    );
  }
}
