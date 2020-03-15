class Entity {

  Map<String, dynamic> __backingFields;
  Map<String, dynamic> get _backingFields {
    if (_backingFields == null) {
      __backingFields = {};
    }
    return _backingFields;
  }

}