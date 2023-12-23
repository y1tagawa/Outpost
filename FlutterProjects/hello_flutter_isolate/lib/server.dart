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

/// セッションのサンプル
final class CounterSession implements ISession {
  final ISessionEventListener _listener;
  int _revision;
  String _state;

  CounterSession._create(ISessionEventListener listener)
      : _listener = listener,
        _revision = 0,
        _state = '0';

  @override
  Future<(int, String)> get(String unused) async => (_revision, _state);

  @override
  Future<(int, String)> post(String unused) async {
    ++_revision;
    _state = _revision.toString();
    return (_revision, _state);
  }

  @override
  Future<void> close() async {
    _listener.close();
  }
}

/// サーバのサンプル
final class CounterServer implements IServer {
  @override
  ISession createSession(ISessionEventListener listener) {
    return CounterSession._create(listener);
  }
}

/// todo: Isolateによるセッション・サーバのサンプル
