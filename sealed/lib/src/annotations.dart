import 'package:meta/meta.dart';

const sealed = Sealed._();

@immutable
class Sealed {
  const Sealed._();
}

const object = Object._();

@immutable
@visibleForTesting
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
