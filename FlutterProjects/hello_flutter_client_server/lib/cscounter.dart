/// クライアント・サーバ・フレームワークによるカウンタ

import 'dart:async';

import 'package:flutter/material.dart';

import 'server_client.dart';

/// ロジック
final class CsCounterSession extends AbstractBasicSession {
  int _revision = 0;
  int _counter = 0;

  /// コンストラクタ
  /// イベントリスナは使用しない
  CsCounterSession._create(ISessionEventListener unused) : super();

  /// ロジック
  @override
  Stream<(int, String)> run(Stream<String> iStream) async* {
    // クライアントからのpost引数の入力ストリーム（イテレータ）
    final is_ = StreamIterator<String>(iStream);
    // 初回get
    yield (_revision, '$_counter');

    for (;;) {
      // 入力待ち
      await is_.moveNext();
      switch (is_.current) {
        case '+':
          // インクリメント
          ++_counter;
          ++_revision;
          yield (_revision, '$_counter');
        case '0':
          // リセット
          if (_counter != 0) {
            _counter = 0;
            ++_revision;
          }
          yield (_revision, '$_counter');
        default:
          throw UnimplementedError();
      }
    }
  }
}

/// セッションサーバ
final class CsCounterServer implements IServer {
  @override
  ISession createSession(ISessionEventListener listener) {
    return CsCounterSession._create(listener);
  }
}

/// カウンタクライアント
///
/// - セッション側の状態をキャッシュし、対応して画面を描画する。
/// - 「+」ボタン押下に対応してセッションにインクリメントを要求する。
/// - 「0」ボタン押下に対応してセッションにリセットを要求する。
/// - セッション側の状態変化を検知したらキャッシュを更新、再描画する。
class CsCounterClient extends StatefulWidget implements ISessionEventListener {
  final String title;

  late final ISession _session;

  CsCounterClient({
    super.key,
    required this.title,
  }) {
    final server = CsCounterServer();
    _session = server.createSession(this);
  }

  @override
  void close() {
    // 終了要求は使用しない。
    throw UnimplementedError();
  }

  @override
  State<CsCounterClient> createState() => _CounterClientState();
}

class _CounterClientState extends State<CsCounterClient> {
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

  // セッションにpostし、レスポンスによって状態キャッシュを更新する。
  void _post(String args) async {
    late final int revision;
    late final String state;
    (revision, state) = await widget._session.post(args);
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
      floatingActionButton: Wrap(
        children: [
          FloatingActionButton(
            onPressed: () async => _post('+'),
            tooltip: '+1',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () async => _post('0'),
            tooltip: 'Reset',
            child: const Icon(Icons.exposure_zero),
          ),
        ],
      ),
    );
  }
}
