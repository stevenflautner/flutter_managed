import 'package:flutter_backend/utils.dart';

class Dependency {

  List<Object> _data;

  Dependency(this._data);

  T of<T>() {
    for (Object object in _data) {
      final type = typeOf<T>();
      if (object.runtimeType == type)
        return object as T;
    }
    throw DependencyNotFoundError();
  }
}

class DependencyNotFoundError extends Error {
  @override
  String toString() => 'Dependency was not found by the provided type';
}
