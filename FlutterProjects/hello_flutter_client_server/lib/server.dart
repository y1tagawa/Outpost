/*

main                          client                        session                       server
  |                             |                             |                             |
  |                                                                                         |
  |-- create(sessionEventListener) -------------------------------------------------------->|
  |<-- session(sessionEventListener) -------------------------------------------------------|
  |                                                                                         |
  |-- create(session) --------->|
  |                             |-- await get --------------->|
  |                             |<-- revision, state ---------|
  |                             |                             |
// loop
  |                             |-- await post -------------->|
  |                             |<-- revision, state ---------|
  |                             |                             |
///loop
  |                             |                             |
  |                             |-- await close ------------->|
  |<-- close -------------------------------------------------|
  |---------------------------------------------------------->|
  |                                                           |---------------------------->|
  |                                                           |<-- dispose -----------------|

 */

/// セッション
abstract class ISession {
  /// 状態
  Future<(int, String)> get(String args);

  /// セッションへの入力
  Future<(int, String)> post(String args);

  /// セッション終了要求
  Future<void> close();
}

/// セッションイベントリスナ
abstract class ISessionEventListener {
  void close();
}

/// セッションサーバ
abstract class IServer {
  /// セッション生成
  ISession createSession(
    /// セッションイベントリスナ
    ISessionEventListener listener,
  );
}

/// todo: Isolateによるセッション・サーバのサンプル
