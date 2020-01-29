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
class DataField<T> {
  final String name;
  const DataField(this.name);
}

//
//@immutable
//class DataField extends Field {
//  final Type type;
//  const DataField(final String name, this.type) : super(name);
//}
//
//@immutable
//class DataList extends Field {
//  final Type intrinsicType;
//
//  const DataList(String name, this.intrinsicType) : super(name);
//}
//
//@immutable
//class DataMap extends Field {
//  final Type keyType;
//  final Type valueType;
//
//  const DataMap(String name, this.keyType, this.valueType) : super(name);
//}

@immutable
class UseClass {
  final Type type;

  const UseClass(this.type);
}
