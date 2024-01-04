// Copyright 2024 Yoshinori Tagawa. All rights reserved.

///  サーバ・クライアントフレームワーク

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'scope_functions.dart';

/*
main                          client                        session                       server
  |                             |                             |                             |
  |-- create ------------------>|
  |                             |-- create(sessionEventListener) -------------------------->|
  |                             |<-- session -----------------------------------------------|
(initialize)
  |                             |-- await get --------------->|
  |                             |<-- revision, state ---------|
(loop)
  |                             |-- await post -------------->|
  |                             |<-- revision, state ---------|
(/loop)
(terminate)
  |                             |-- await post (close) ------>|
  |                             |<-- close -------------------|
  |                             |---------------------------->|
  |                                                           |-- disconnect -------------->|
  |                                                           |<-- dispose -----------------|
 */

/// セッション
abstract class ISession {
  /// 現在状態を取得する。
  Future<
      (
        /// 現在状態のリビジョン
        int,

        /// 現在状態
        String,
      )> get(String args);

  /// セッションへの要求を処理し、結果の状態を取得する。
  Future<
      (
        /// 要求処理後の状態のリビジョン
        /// 状態変化と同時にインクリメントされるよう実装するべし。
        int,

        /// 要求処理後の状態
        String,
      )> post(String args);
}

/// セッションイベントリスナ
abstract class ISessionEventListener {
  /// セッションからクライアントへの終了要求
  void close();
}

/// セッションサーバ
abstract class IServer {
  /// イベントリスナに対応するセッションを生成する。
  ISession createSession(
    /// セッションイベントリスナ
    ISessionEventListener listener,
  );
}

/// サーバ側ロジックを非同期関数で実装するセッション
///
/// 時間がかからないロジック用。
abstract class AbstractBasicSession implements ISession {
  final _logger = Logger('AbstractBasicSession');

  /// post引数のロジックへの入力ストリーム（コントローラ）
  final _is = StreamController<String>();

  /// ロジックからの出力ストリーム（イテレータ）
  StreamIterator<(int, String)>? _os;

  /// 派生クラスで実装すべきロジック
  /// 最初に一回getに対応して呼び出されるので、初回のyieldまでには必ず状態変数の初期化のみを行うこと。
  @protected
  Stream<(int, String)> run(
    ///ロジックへの入力ストリーム
    Stream<String> iStream,
  );

  /// 現在状態を返す。ただしロジックが起動されていない場合はその前に初回起動し、状態を初期化する。
  /// argsは既定では使用しない。
  @override
  Future<(int, String)> get(String args) async {
    _logger.fine('[i] get args=\'$args\', _os=$_os');
    if (_os == null) {
      _logger.fine('get run');
      _os = StreamIterator(run(_is.stream));
      _logger.fine('waiting response');
      await _os!.moveNext();
      _logger.fine('received response');
    }
    return _os!.current.also(
      (it) {
        _logger.fine('[o] get (revision, state)=$it');
      },
    );
  }

  /// postし、結果の現在状態を返す。ただしロジックが起動されていない場合はpostの前に初回起動し初期化する。
  @override
  Future<(int, String)> post(String args) async {
    _logger.fine('[i] post args=\'$args\', _os=$_os');
    if (_os == null) {
      _logger.fine('post run');
      _os = StreamIterator(run(_is.stream));
      _logger.fine('waiting response');
      await _os!.moveNext().also(
        (it) {
          _logger.fine('received response (revision, state)=$it');
        },
      );
    }
    _logger.fine('posting args=\'$args\'');
    _is.add(args);
    _logger.fine('waiting response');
    await _os!.moveNext();
    _logger.fine('received response');
    return _os!.current.also(
      (it) {
        _logger.fine('[o] post (revision, state)=$it');
      },
    );
  }
}
