/// クライアント・サーバ・フレームワークのサンプル
///
/// todo: isolateによるモーダルなセッションのサンプル（JKP, AMHとか）

import 'dart:async';
import 'dart:convert';
import 'dart:math';

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

//
// JkpAmh
//

// 画面モード
enum Mode {
  jkp, // ジャンケンポン
  aks, // あいこでしょ
  aiAmh, // AIがあっちむいてホイ
  huAmh, // 人間があっちむいてホイ
  aiWin, // AIの勝ち
  huWin, // 人間の勝ち
  draw, // 引き分け
}

enum Gcp {
  g,
  c,
  p;

  bool wins(Gcp other) =>
      this == g && other == c || this == c && other == p || this == p && other == g;
}

enum Dir { up, down, left, right }

abstract class LogicWrapper implements ISession {
  /// ロジックへの入力ストリーム（コントローラ）
  final _is = StreamController<String>();

  /// ロジックからの出力ストリーム（イテレータ）
  StreamIterator<(int, String)>? _os;

  /// ロジック
  /// 最初に一回getに対応して呼び出されるので、初回のyieldまでには必ず状態変数の初期化のみを行うこと。
  Stream<(int, String)> run(
    ///ロジックへの入力ストリーム
    Stream<String> iStream,
  );

  // ロジックが起動されていない場合のみ初回起動する。
  Future<void> _run() async {
    if (_os == null) {
      _os = StreamIterator(run(_is.stream));
      await _os!.moveNext();
    }
  }

  /// ロジックからの出力を、必要に応じ変換する。
  /// 例えば状態変数が巨大なとき、ロジックの返値やメンバ変数等から一部抽出するなど。
  @protected
  String filterState(
    /// getまたはpostの引数
    String args,

    /// ロジックの出力
    String state,
  ) {
    // デフォルトではロジックの出力をそのまま返す。
    return state;
  }

  /// ロジックが起動されていない場合は初回起動し、以後現在状態を返す。
  @override
  Future<(int, String)> get(String args) async {
    await _run();
    return (_os!.current.$1, filterState(args, _os!.current.$2));
  }

  /// ロジックが起動されていない場合は初回起動し、以後postの結果状態を返す。
  @override
  Future<(int, String)> post(String args) async {
    await _run();
    _is.add(args);
    await _os!.moveNext();
    return (_os!.current.$1, filterState(args, _os!.current.$2));
  }
}

/// ロジック
class JkpAmh extends LogicWrapper {
  // 状態変数
  int _revision = 0;
  Mode? _mode;
  bool? _isJkp;
  Gcp? _aiGcp;
  Gcp? _huGcp;
  Dir? _aiDir;
  Dir? _huDir;

  @override
  Stream<(int, String)> run(Stream<String> iStream) async* {
    // クライアントからの入力ストリーム（イテレータ）
    final is_ = StreamIterator<String>(iStream);

    const aiGcps = [Gcp.g, Gcp.c, Gcp.p];
    const aiDirs = [Dir.up, Dir.down, Dir.left, Dir.right];

    int revision = 0;
    for (;;) {
      for (_isJkp = true;;) {
        // 一回目ならジャンケンポン、二回目以後ならあいこでしょ
        _mode = _isJkp! ? Mode.jkp : Mode.aks;
        // その他の初期値
        _aiGcp = _huGcp = _aiDir = _aiDir = null;
        // ジャンケン入力画面（初回get）
        yield (_revision++, '');

        // AI選択
        final aiGcp = aiGcps[Random().nextInt(aiGcps.length)];
        // 人間のジャンケンpost待ち
        await is_.moveNext();
        // todo: 入力バリデーション
        final huGcp = Gcp.values.byName(is_.current);

        if (aiGcp == huGcp) {
          // あいこの場合、ジャンケンに戻る
          _isJkp = false;
          continue;
        }

        // あっちむいて入力画面
        _mode = aiGcp.wins(huGcp) ? Mode.aiAmh : Mode.huAmh;
        yield (revision++, '');

        // AI方向選択
        _aiDir = aiDirs[Random().nextInt(aiDirs.length)];
        // 人間方向post待ち
        await is_.moveNext();
        // todo: 入力バリデーション
        _huDir = Dir.values.byName(is_.current);

        if (_aiDir == _huDir) {
          // 勝敗画面
          _mode = (_mode == Mode.aiAmh) ? Mode.aiWin : Mode.huWin;
        } else {
          // 引き分け画面
          _mode = Mode.draw;
        }
        // OK入力待ち
        yield (revision++, '');
        is_.moveNext();
      }
    }
  }

  @override
  String filterState(String args, String state) {
    final map = {
      'mode': _mode?.name,
      'isJkp': _isJkp,
      'aiGcp': _aiGcp?.name,
      'huGcp': _huGcp?.name,
      'aiDir': _aiDir?.name,
      'huDir': _huDir?.name,
    };
    return jsonEncode(map);
  }
}
