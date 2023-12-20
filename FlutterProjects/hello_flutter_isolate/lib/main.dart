import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final logger = Logger('hello_flutter_isolate');

late final ReceivePort clientReceivePort;
late final StreamIterator<Object?> clientReceiveIterator;

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  clientReceivePort = ReceivePort("clientReceivePort");
  clientReceiveIterator = StreamIterator(clientReceivePort);

  await Isolate.spawn(_server, clientReceivePort.sendPort);

  runApp(const MyApp());
}

void _server(SendPort sendPort) async {
  final serverLogger = Logger('serverLogger');

  serverLogger.fine('[i] _server');
  //await for (;;) {
  serverLogger.fine('_server 1');
  sendPort.send(1);
  serverLogger.fine('_server 2');
  sendPort.send(2);
  //}
  serverLogger.fine('[o] _server');
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _digit = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Digit is:',
            ),
            Text(
              '$_digit',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await clientReceiveIterator.moveNext();
          setState(() {
            if (clientReceiveIterator.current is int) {
              _digit = clientReceiveIterator.current as int;
              logger.fine('client received from port: $_digit');
            }
          });
        },
        tooltip: 'Next',
        child: const Icon(Icons.navigate_next),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
