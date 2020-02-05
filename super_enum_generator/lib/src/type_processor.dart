import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:super_enum/super_enum.dart';

TypeChecker _typeChecker(Type t) => TypeChecker.fromRuntime(t);

String dataFieldName(obj) => ConstantReader(obj).read('name').stringValue;

ConstantReader annotationOf<T>(obj) =>
    ConstantReader(_typeChecker(T).firstAnnotationOfExact(obj));

ConstantReader fieldOf<T>(obj, String fieldName) =>
    annotationOf<T>(obj)?.read(fieldName);

Iterable listTypeFieldOf<T>(obj, String fieldName) =>
    fieldOf<T>(obj, fieldName)?.listValue ?? [];

bool hasAnnotation<T>(obj) => _typeChecker(T).hasAnnotationOfExact(obj);

bool isGeneric(Element element) =>
    _typeChecker(Generic).hasAnnotationOfExact(element);

String dataFieldType(obj) {
  return _genericOf(ConstantReader(obj).objectValue.type)
      .displayName
      .replaceAll('Generic', 'T');
}

DartType _genericOf(DartType type) {
  return type is InterfaceType && type.typeArguments.isNotEmpty
      ? type.typeArguments.first
      : null;
}

DartObject usedClassFromAnnotation(FieldElement field) {
  final annotation =
      TypeChecker.fromRuntime(UseClass).firstAnnotationOfExact(field);
  if (annotation == null) return null;
  final DartObject usedClass = annotation.getField('type');
  return usedClass;
}
