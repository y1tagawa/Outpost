import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final logger = Logger('hello_flutter_isolate');

late final ReceivePort receiveFromServerPort;
late final StreamIterator<Object?> receiveFromServerIterator;
late final SendPort sendToServerPort;

/*
  クライアント
 */
void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  //  サーバ起動
  receiveFromServerPort = ReceivePort("clientReceivePort");
  receiveFromServerIterator = StreamIterator(receiveFromServerPort);
  await Isolate.spawn(_server, receiveFromServerPort.sendPort);

  //  最初にサーバへのSendPortを受け取る
  await receiveFromServerIterator.moveNext();
  sendToServerPort = receiveFromServerIterator.current as SendPort;

  runApp(const MyApp());
}

/*
  クライアントとキャッチボールするサーバ
 */
void _server(SendPort sendPort) async {
  final isolateLogger = Logger('isolateLogger');

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  //debugPrint('[i] _server');
  isolateLogger.fine('[i] _server');

  final receiveFromClientPort = ReceivePort('receiveFromClientPort');
  final receiveFromClientIterator = StreamIterator(receiveFromClientPort);

  // 最初にサーバへのSendPortを送る
  sendPort.send(receiveFromClientPort.sendPort);

  // 以後、クライアントからの入力を待ち、返信する無限ループに入る。
  for (;;) {
    isolateLogger.fine('_server awaits');
    // クライアントからの入力待ち
    await receiveFromClientIterator.moveNext();
    final input = receiveFromClientIterator.current as int;
    // 返信
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
  int _counter = 0;

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
              'Counter is:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // FABがクリックされたら、サーバに現在のカウンタ値を送る
          logger.fine('sending to server $_counter');
          sendToServerPort.send(_counter);
          // サーバからの返信待ち
          logger.fine('client awaits');
          await receiveFromServerIterator.moveNext();
          // 受け取った値でカウンタ更新
          setState(() {
            logger.fine('client received ${receiveFromServerIterator.current}');
            _counter = receiveFromServerIterator.current as int;
          });
        },
        tooltip: 'Next',
        child: const Icon(Icons.navigate_next),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
