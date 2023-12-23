import 'package:flutter/material.dart';

import 'server.dart';

///
void main() {
  runApp(const MyApp());
}

/// カウンタセッション
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

/// カウンタセッションサーバ
final class CounterServer implements IServer {
  @override
  ISession createSession(ISessionEventListener listener) {
    return CounterSession._create(listener);
  }
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// カウンタクライアント
///
class MyHomePage extends StatefulWidget implements ISessionEventListener {
  final String title;

  late final ISession _session;

  MyHomePage({
    super.key,
    required this.title,
  }) {
    final server = CounterServer();
    _session = server.createSession(this);
  }

  @override
  void close() {
    // TODO: implement close
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _revision = -1;
  late String _state = '';

  @override
  void initState() {
    super.initState();

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

  void _incrementCounter() async {
    late final int revision;
    late final String state;
    (revision, state) = await widget._session.post('unused');
    if (revision != _revision) {
      setState(() {
        _revision = revision;
        _state = state;
      });
    }
  }

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
              'You have pushed the button this many times:',
            ),
            Text(
              _state,
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
