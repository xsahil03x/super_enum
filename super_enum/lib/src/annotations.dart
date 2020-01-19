import 'package:meta/meta.dart';

const superEnum = SuperEnum._();

@immutable
class SuperEnum {
  const SuperEnum._();
}

const object = Object._();

@immutable
class Object {
  const Object._();
}

@immutable
class Data {
  final List<DataField> fields;

  const Data({@required this.fields});
}

const generic = Generic._();

@immutable
class Generic {
  const Generic._();
}

@immutable
class DataField {
  final String name;
  final Type type;

  const DataField(this.name, this.type);
}

@immutable
class UseClass {
  final Type type;

  const UseClass(this.type);
}
