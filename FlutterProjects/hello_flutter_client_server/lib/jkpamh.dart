/// JkpAmhサーバ・クライアント

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'server_client.dart';

// 画面モード
enum Mode {
  jkp, // ジャンケンポン
  aks, // あいこでしょ
  aiAmh, // AIがあっち向いてホイ
  huAmh, // 人間があっち向いてホイ
  aiWin, // AIの勝ち
  huWin, // 人間の勝ち
  draw, // 引き分け
}

// ジャンケン
enum Gcp {
  g,
  c,
  p;

  bool wins(Gcp other) =>
      this == g && other == c || this == c && other == p || this == p && other == g;
}

// あっち向いて
enum Dir { up, down, left, right }

/// あっち向いてホイのロジック
///
final class JkpAmhSession extends AbstractBasicSession {
  /// コンストラクタ
  /// イベントリスナは使用しない
  JkpAmhSession._create(ISessionEventListener unused) : super();

  /// ロジック
  @override
  Stream<(int, String)> run(Stream<String> iStream) async* {
    // クライアントからのpost引数の入力ストリーム（イテレータ）
    final is_ = StreamIterator<String>(iStream);

    const aiGcps = [Gcp.g, Gcp.c, Gcp.p];
    const aiDirs = [Dir.up, Dir.down, Dir.left, Dir.right];

    String makeState({
      required Mode mode,
      Gcp? aiGcp,
      Gcp? huGcp,
      Dir? aiDir,
      Dir? huDir,
    }) {
      final map = {
        'mode': mode.name,
        'aiGcp': aiGcp?.name,
        'huGcp': huGcp?.name,
        'aiDir': aiDir?.name,
        'huDir': huDir?.name,
      };
      return jsonEncode(map);
    }

    for (int revision = 0;;) {
      for (bool isJkp = true;;) {
        // 一回目ならジャンケンポン、二回目以後ならあいこでしょ
        Mode mode = isJkp ? Mode.jkp : Mode.aks;
        // ジャンケン入力画面（初回get）
        yield (++revision, makeState(mode: mode));

        // AI選択
        final aiGcp = aiGcps[Random().nextInt(aiGcps.length)];
        // 人間のジャンケンpost待ち
        await is_.moveNext();
        // todo: 入力バリデーション
        final huGcp = Gcp.values.byName(is_.current);

        if (aiGcp == huGcp) {
          // あいこの場合、ジャンケンに戻る
          isJkp = false;
          continue;
        }

        // あっち向いて入力画面
        mode = aiGcp.wins(huGcp) ? Mode.aiAmh : Mode.huAmh;
        yield (++revision, makeState(mode: mode, aiGcp: aiGcp, huGcp: huGcp));

        // AI方向選択
        final aiDir = aiDirs[Random().nextInt(aiDirs.length)];
        // 人間方向post待ち
        await is_.moveNext();
        // todo: 入力バリデーション
        final huDir = Dir.values.byName(is_.current);

        if (aiDir == huDir) {
          // 勝ち負け画面
          mode = (mode == Mode.aiAmh) ? Mode.aiWin : Mode.huWin;
        } else {
          // 引き分け画面
          mode = Mode.draw;
        }
        // OK入力待ち
        yield (
          ++revision,
          makeState(mode: mode, aiGcp: aiGcp, huGcp: huGcp, aiDir: aiDir, huDir: huDir),
        );
        is_.moveNext();
        break;
      }
    }
  }
}

/// JkpAmhセッションサーバ
final class JkpAmhServer implements IServer {
  @override
  ISession createSession(ISessionEventListener listener) {
    return JkpAmhSession._create(listener);
  }
}

/// JkpAmhクライアント
///
/// - セッション側の状態をキャッシュし、対応して画面を描画する。
/// - 画面からの入力をセッションにpostし、状態変化を検知したらキャッシュを更新、再描画する。
class JkpAmhClient extends StatefulWidget implements ISessionEventListener {
  final String title;

  late final ISession _session;

  JkpAmhClient({
    super.key,
    required this.title,
  }) {
    final server = JkpAmhServer();
    _session = server.createSession(this);
  }

  @override
  void close() {
    // 終了要求は使用しない。
    throw UnimplementedError();
  }

  @override
  State<JkpAmhClient> createState() => _JkpAmhClientState();
}

const _textStyle = TextStyle(fontSize: 24);
const _iconStyle = TextStyle(fontSize: 32);

const _gIcon = Text('\u{270a}', style: _iconStyle);
const _cIcon = Text('\u{270c}', style: _iconStyle);
const _pIcon = Text('\u{1f590}', style: _iconStyle);
const _gcpIcons = {
  Gcp.g: _gIcon,
  Gcp.c: _cIcon,
  Gcp.p: _pIcon,
};

const _upIcon = Text('\u{1f446}', style: _iconStyle);
const _downIcon = Text('\u{1f447}', style: _iconStyle);
const _leftIcon = Text('\u{1f448}', style: _iconStyle);
const _rightIcon = Text('\u{1f449}', style: _iconStyle);
const _dirIcons = {
  Dir.up: _upIcon,
  Dir.down: _downIcon,
  Dir.left: _leftIcon,
  Dir.right: _rightIcon,
};

/// ジャンケンポン画面
///
/// 人間のジャンケン入力待ち。
class _JkpWidget extends StatelessWidget {
  final String title;
  final void Function(Gcp jkp) onJkp;

  const _JkpWidget({super.key, required this.title, required this.onJkp});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => onJkp(Gcp.g), icon: _gIcon),
              IconButton(onPressed: () => onJkp(Gcp.c), icon: _cIcon),
              IconButton(onPressed: () => onJkp(Gcp.p), icon: _pIcon),
            ],
          ),
        ],
      ),
    );
  }
}

/// あっち向いてホイ画面
///
/// ジャンケン結果を表示、人間のあっちむいてホイを入力待ち。
class _AmhWidget extends StatelessWidget {
  final String title;
  final Gcp aiGcp;
  final Gcp huGcp;
  final void Function(Dir dir) onAmh;

  const _AmhWidget({
    super.key,
    required this.title,
    required this.aiGcp,
    required this.huGcp,
    required this.onAmh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('人間: ${_gcpIcons[huGcp]!.data!}'),
          Text('AI: ${_gcpIcons[aiGcp]!.data!}'),
          Text(title, textAlign: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => onAmh(Dir.left), icon: _leftIcon),
              IconButton(onPressed: () => onAmh(Dir.up), icon: _upIcon),
              IconButton(onPressed: () => onAmh(Dir.down), icon: _downIcon),
              IconButton(onPressed: () => onAmh(Dir.right), icon: _rightIcon),
            ],
          ),
        ],
      ),
    );
  }
}

/// 勝ち負け引き分け画面
///
///　あっち向いてホイ結果を表示、OK入力待ち。
class _OkWidget extends StatelessWidget {
  final String title;
  final Dir aiDir;
  final Dir huDir;
  final void Function() onOk;

  const _OkWidget({
    super.key,
    required this.title,
    required this.aiDir,
    required this.huDir,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('人間: ${_dirIcons[huDir]!.data!}'),
          Text('AI: ${_dirIcons[aiDir]!.data!}'),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: onOk,
              child: const Text(
                'OK',
                style: _textStyle,
              )),
        ],
      ),
    );
  }
}

class _JkpAmhClientState extends State<JkpAmhClient> {
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
      body: DefaultTextStyle.merge(
        style: _textStyle,
        child: Center(
          child: _revision == null
              ? const CircularProgressIndicator()
              : () {
                  final map = jsonDecode(_state!);
                  final mode = Mode.values.byName(map['mode']!);
                  switch (mode) {
                    case Mode.jkp:
                    case Mode.aks:
                      return _JkpWidget(
                        title: mode == Mode.jkp ? 'ジャンケンポン' : 'あいこでしょ',
                        onJkp: (Gcp gcp) async => _post(gcp.name),
                      );
                    case Mode.aiAmh:
                    case Mode.huAmh:
                      return _AmhWidget(
                        title: mode == Mode.aiAmh ? 'AIのあっち向いてホイ' : '人間のあっち向いてホイ',
                        aiGcp: Gcp.values.byName(map['aiGcp']!),
                        huGcp: Gcp.values.byName(map['huGcp']!),
                        onAmh: (Dir dir) async => _post(dir.name),
                      );
                    case Mode.aiWin:
                    case Mode.huWin:
                    case Mode.draw:
                      final titles = {
                        Mode.aiWin: 'AIの勝ち',
                        Mode.huWin: '人間の勝ち',
                        Mode.draw: '引き分け',
                      };
                      return _OkWidget(
                        title: titles[mode]!,
                        aiDir: Dir.values.byName(map['aiDir']!),
                        huDir: Dir.values.byName(map['huDir']!),
                        onOk: () async => _post('ok'),
                      );
                  }
                }(),
        ),
      ),
    );
  }
}
