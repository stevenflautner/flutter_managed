import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Locator _locator;

T get<T>() => _locator<T>();
//T depends<T>(BuildContext context) => Provider.of<T>(context);
//T provide<T>(BuildContext context) => Provider.of<T>(context, listen: false);

extension Provide on BuildContext {
  T get<T>() => Provider.of<T>(this, listen: false);
  T depends<T>() => Provider.of<T>(this);
}

SingleChildCloneableWidget Pass<T>(T value, { Widget child }) {
  if (T is ChangeNotifier) return ChangeNotifierProvider.value(value: value as ChangeNotifier, child: child);
  return Provider.value(value: value, child: child);
}

void service<T>(T service) =>  _locator.registerConstant(service);
void lazyService<T>(_Builder<T> service) =>  _locator.registerLazy(service);
void repository<T>(_Builder<T> repository) =>  _locator.registerLazy(repository);

class Locator {

  final _instances = Map<Type, _Instance<dynamic>>();

  Locator() {
    if (_locator != null) throw ArgumentError('Locator was already initialized');
    _locator = this;
  }

  T call<T>() => get<T>();

  T get<T>() {
    final instance = _instances[T];
    if (instance == null) throw ArgumentError("Object not registered for type $T");
    return instance.get() as T;
  }

  void registerConstant<T>(T instance) => _instances[T] = _Constant(instance);
  void registerLazy<T>(_Builder<T> builder) => _instances[T] = _Lazy(builder);
  void registerFactory<T>(_Builder<T> builder) => _instances[T] = _Factory(builder);

//  void style<T>(T style) =>  _registerConstant(style);
//  void service<T>(T service) =>  _registerConstant(service);
//  void lazyService<T>(Builder<T> service) =>  _registerLazy(service);
//  void repository<T>(Builder<T> repository) =>  _registerLazy(repository);

}

abstract class _Instance<T> {
  T get();
}
class _Constant<T> implements _Instance<T> {
  final T instance;

  const _Constant(this.instance);

  @override
  T get() => instance;
}
class _Factory<T> implements _Instance<T> {
  final _Builder<T> builder;

  const _Factory(this.builder);

  @override
  T get() => builder();
}
class _Lazy<T> implements _Instance<T> {
  final _Builder<T> builder;
  T instance;

  _Lazy(this.builder);

  @override
  T get() {
    if (instance == null)
      instance = builder();
    return instance;
  }
}

typedef _Builder<T> = T Function();