import 'package:meta/meta.dart';

const sealed = SealedUgh();

@immutable
class SealedUgh {
  const SealedUgh();
}

const object = Object();

@immutable
class Object {
  const Object();
}

@immutable
class Data {
  final List<DataField> fields;
  const Data({@required this.fields});
}

const generic = Generic();

@immutable
class Generic {
  const Generic();
}

@immutable
class DataField {
  final String name;
  final Type type;
  const DataField(this.name, this.type);
}
