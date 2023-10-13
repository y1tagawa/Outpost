// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final _pingEnabledProvider = StateProvider<bool>((ref) => true);
final _resultProvider = StateProvider<String>((ref) => '');

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
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hello Flutter Method Channel'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  static const methodChannel = MethodChannel('method/ping');

  Future<Map<Object?, Object?>> _ping() async {
    return await methodChannel.invokeMethod('ping', {});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pingEnabled = ref.watch(_pingEnabledProvider);
    final result = ref.watch(_resultProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(result),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pingEnabled
            ? () async {
                ref.read(_pingEnabledProvider.notifier).state = false;
                final result = await _ping();
                Logger().d(result);
                ref.read(_resultProvider.notifier).state =
                    'device=${result['device']} message=${result['message']}';
                ref.read(_pingEnabledProvider.notifier).state = true;
              }
            : null,
        tooltip: 'Ping',
        backgroundColor: pingEnabled ? null : Theme.of(context).disabledColor,
        child: Icon(pingEnabled ? Icons.notifications : Icons.notifications_none),
      ),
    );
  }
}
