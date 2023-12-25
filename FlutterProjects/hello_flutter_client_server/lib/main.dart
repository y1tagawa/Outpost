/// クライアント・サーバ・フレームワークのサンプル
///
/// todo: isolateによるモーダルなセッションのサンプル（JKP, AMHとか）

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'server_client.dart';

final logger = Logger('hello_flutter_client_server');

void main() {
  Logger.root.level = Level.ALL;
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
      home: CounterClient(title: 'Flutter Demo Home Page'),
    );
  }
}

//
//  クライアント・サーバ・フレームワークによるカウンタ
//

/// カウンタセッション
final class CounterSession implements ISession {
  int _revision;
  String _state;

  CounterSession._create(ISessionEventListener unused)
      : _revision = 0,
        _state = '0';

  @override
  Future<(int, String)> get(String unused) async {
    logger.fine('CounterSession.get');
    return (_revision, _state);
  }

  @override
  Future<(int, String)> post(String unused) async {
    logger.fine('CounterSession.post');
    // 状態変化
    ++_revision;
    _state = _revision.toString();
    return (_revision, _state);
  }
}

/// カウンタセッションサーバ
final class CounterServer implements IServer {
  @override
  ISession createSession(ISessionEventListener listener) {
    return CounterSession._create(listener);
  }
}

//
//  クライアント・サーバ・フレームワークによるカウンタ2
//
//  ロジックを非同期関数にできるか実験。できるなら、ロジック中でモード（ループのネスト）とかも使えるはず。
//

/// カウンタロジック
Stream<(int, String)> _counterLogic(Stream<String> receiveStream) async* {
  logger.fine('[i]_counterLogic');

  final receiveStreamIterator = StreamIterator(receiveStream);

  int revision = 0;
  String state = '0';

  Stream<(int, String)> counterLogicInner() async* {
    for (;;) {
      await receiveStreamIterator.moveNext();
      switch (receiveStreamIterator.current) {
        case 'post':
          logger.fine('counterLogicInner.post');
          ++revision;
          state = '${revision}_A';
          yield (revision, state);
          if (revision >= 6) {
            logger.fine('returning to base');
            return;
          }
        default:
          throw UnimplementedError();
      }
    }
  }

  for (;;) {
    await receiveStreamIterator.moveNext();
    switch (receiveStreamIterator.current) {
      case 'get':
        logger.fine('_counterLogic.get');
        yield (revision, state);
      case 'post':
        logger.fine('_counterLogic.post');
        ++revision;
        state = revision.toString();
        yield (revision, state);
        if (revision >= 3) {
          logger.fine('calling inner');
          yield* counterLogicInner();
        }
      default:
        throw UnimplementedError();
    }
  }
}

/// カウンタセッション
final class CounterSession2 implements ISession {
  late StreamController<String> _sendStreamController;
  late StreamIterator<(int, String)> _receiveStreamIterator;

  CounterSession2._create(ISessionEventListener unused) {
    _sendStreamController = StreamController<String>();
    final receiveStream = _counterLogic(_sendStreamController.stream);
    _receiveStreamIterator = StreamIterator(receiveStream);
  }

  @override
  Future<(int, String)> get(String unused) async {
    logger.fine('CounterLogic2.get');
    _sendStreamController.add('get');
    await _receiveStreamIterator.moveNext();
    return _receiveStreamIterator.current;
  }

  @override
  Future<(int, String)> post(String unused) async {
    logger.fine('CounterLogic2.post');
    _sendStreamController.add('post');
    await _receiveStreamIterator.moveNext();
    return _receiveStreamIterator.current;
  }
}

/// カウンタセッションサーバ
final class CounterServer2 implements IServer {
  @override
  ISession createSession(ISessionEventListener listener) {
    return CounterSession2._create(listener);
  }
}

/// カウンタクライアント
///
/// - セッション側の状態をキャッシュし、対応して画面を描画する。
/// - 「+」ボタン押下に対応してセッションにインクリメントを要求する。
/// - セッション側の状態変化を検知したらキャッシュを更新、再描画する。
class CounterClient extends StatefulWidget implements ISessionEventListener {
  final String title;

  late final ISession _session;

  CounterClient({
    super.key,
    required this.title,
  }) {
    //final server = CounterServer();
    final server = CounterServer2();
    _session = server.createSession(this);
  }

  @override
  void close() {
    // 終了要求は使用しない。
    throw UnimplementedError();
  }

  @override
  State<CounterClient> createState() => _CounterClientState();
}

class _CounterClientState extends State<CounterClient> {
  // 状態キャッシュ（nullは未初期化を意味する）
  int? _revision;
  String? _state;

  @override
  void initState() {
    super.initState();

    // 状態キャッシュを非同期的に初期化する。
    Future(() async {
      final int revision;
      final String state;
      (revision, state) = await widget._session.get('unused');
      setState(() {
        _revision = revision;
        _state = state;
      });
    });
  }

  // セッションにカウントアップを要求し、レスポンスによって状態キャッシュを更新する。
  void _incrementCounter() async {
    late final int revision;
    late final String state;
    (revision, state) = await widget._session.post('unused');
    if (revision != _revision) {
      // 状態変化を検知した。
      setState(() {
        _revision = revision;
        _state = state;
      });
    }
  }

  // 状態キャッシュの値により画面の再描画を行う。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _revision == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    _state!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
