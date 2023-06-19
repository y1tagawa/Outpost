// Copyright 2023 Yoshinori Tagawa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hello_flutter/analog_clock.dart';
import 'package:hello_flutter/timer_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  static final _logger = Logger((MyApp).toString());

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.fine('[i] build');

    return MaterialApp(
      title: 'The OK Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'The OK Clock'),
    );
  }
}

final _dateTimeNotifier = ValueNotifier(DateTime.now());

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final clockDimension = math.min(mediaQuery.size.width, mediaQuery.size.height) * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: TimerController.periodic(
        duration: const Duration(milliseconds: 200),
        onPeriodic: (_) {
          final now = DateTime.now();
          final value = _dateTimeNotifier.value;
          if (now.second != value.second ||
              now.minute != value.minute ||
              now.hour != value.hour ||
              now.day != value.day ||
              now.month != value.month ||
              now.year != value.year) {
            _dateTimeNotifier.value = now;
            //_logger.fine('update');
          }
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/okcat.png',
                width: clockDimension * 0.7,
                height: clockDimension * 0.7,
              ),
              AnalogClock(
                size: Size(clockDimension, clockDimension),
                faceColor: const Color(0x00000000),
                dateTimeNotifier: _dateTimeNotifier,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
