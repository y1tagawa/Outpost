/// スコープ関数

extension ScopeFunctions<T> on T {
  T also(void Function(T it) f) {
    f.call(this);
    return this;
  }

  U let<U>(U Function(T it) f) {
    return f.call(this);
  }
}

U run<U>(U Function() f) => f.call();
