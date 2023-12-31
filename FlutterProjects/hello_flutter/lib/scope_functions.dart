// Copyright 2023 Yoshinori Tagawa. All rights reserved.

// Scope function alternatives.

T run<T>(T Function() fun) => fun();

extension ScopeFunctions<T> on T {
  T also(void Function(T it) fun) {
    fun(this);
    return this;
  }

  U let<U>(U Function(T it) fun) => fun(this);
}
