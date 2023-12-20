import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final logger = Logger('hello_flutter_isolate');

late final ReceivePort receiveFromServerPort;
late final StreamIterator<Object?> receiveFromServerIterator;
late final SendPort sendToServerPort;

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  receiveFromServerPort = ReceivePort("clientReceivePort");
  receiveFromServerIterator = StreamIterator(receiveFromServerPort);

  await Isolate.spawn(_server, receiveFromServerPort.sendPort);

  await receiveFromServerIterator.moveNext();
  sendToServerPort = receiveFromServerIterator.current as SendPort;

  runApp(const MyApp());
}

void _server(SendPort sendPort) async {
  final isolateLogger = Logger('isolateLogger');

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  //debugPrint('[i] _server');
  isolateLogger.fine('[i] _server');

  final receiveFromClientPort = ReceivePort('receiveFromClientPort');
  sendPort.send(receiveFromClientPort.sendPort);
  final receiveFromClientIterator = StreamIterator(receiveFromClientPort);

  for (;;) {
    isolateLogger.fine('_server awaits');
    await receiveFromClientIterator.moveNext();
    final input = receiveFromClientIterator.current;
    isolateLogger.fine('_server received input=[$input] and sending ${input + 1}');
    sendPort.send(input + 1);
  }
  //isolateLogger.fine('[o] _server');
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
          logger.fine('sending to server $_digit');
          sendToServerPort.send(_digit);

          logger.fine('client awaits');
          await receiveFromServerIterator.moveNext();
          setState(() {
            if (receiveFromServerIterator.current is int) {
              _digit = receiveFromServerIterator.current as int;
              logger.fine('client received $_digit');
            }
          });
        },
        tooltip: 'Next',
        child: const Icon(Icons.navigate_next),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
