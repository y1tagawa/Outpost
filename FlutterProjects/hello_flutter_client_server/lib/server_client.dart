//  サーバ・クライアントフレームワーク

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

/// todo: Isolateによるセッション・サーバのサンプル
