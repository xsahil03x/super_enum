import 'package:meta/meta.dart';

/// An annotation for the `super_enum` package.
///
/// Annotating a enum with this annotation will flag it as needing to be
/// processed by the `super_enum` code generator.
const superEnum = SuperEnum._();

@immutable
class SuperEnum {
  const SuperEnum._();
}

/// Marks the enum value as [ObjectClass].
///
/// This generates a `singleton` class similar to Object Classes in Kotlin.
const object = ObjectClass._();

@immutable
class ObjectClass {
  const ObjectClass._();
}

/// Marks the enum value as `DataClass`.
///
/// This generates a class similar to Data Classes in Kotlin.
@immutable
class Data {
  final List<DataField> fields;

  const Data({required this.fields});
}

/// Mark the generated type as generic.
///
/// This enables the use of generic type in [DataField].
const generic = Generic._();

@immutable
class Generic {
  const Generic._();
}

/// Allows passing fields to a [Data] class:
///
/// ```dart
/// @Data(fields: [DataField<Movies>('movies')])
/// Success,
/// ```
///
/// is equivalent to:
///
/// ```dart
/// @immutable
/// class Success {
///   const Success({@required this.movies});
///
///   final Movies movies;
///
///   @override
///   String toString() => 'Success(movies:${this.movies})';
/// }
/// ```
@immutable
class DataField<T> {
  final String name;
  final bool required;

  const DataField(this.name, {this.required = true});
}

/// Marks the class as a [UseClass]
///
/// This enables the user to directly reuse the classes as `Union Type`
/// without having them auto-generated.
@immutable
class UseClass {
  final Type type;
  final String name;

  const UseClass(this.type, {required this.name});
}
