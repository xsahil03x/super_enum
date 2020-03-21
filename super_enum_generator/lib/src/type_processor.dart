import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:super_enum/super_enum.dart';

TypeChecker _typeChecker(Type t) => TypeChecker.fromRuntime(t);

String dataFieldName(DartObject obj) => ConstantReader(obj).read('name').stringValue;

bool dataFieldRequired(DartObject obj) => ConstantReader(obj).read('required').boolValue;

ConstantReader annotationOf<T>(Element obj) =>
    ConstantReader(_typeChecker(T).firstAnnotationOfExact(obj));

ConstantReader fieldOf<T>(Element obj, String fieldName) =>
    annotationOf<T>(obj)?.read(fieldName);

Iterable<DartObject> listTypeFieldOf<T>(Element obj, String fieldName) =>
    fieldOf<T>(obj, fieldName)?.listValue ?? [];

bool hasAnnotation<T>(Element obj) => _typeChecker(T).hasAnnotationOfExact(obj);

bool isGeneric(Element element) =>
    _typeChecker(Generic).hasAnnotationOfExact(element);

String dataFieldType(DartObject obj) {
  return _genericOf(ConstantReader(obj).objectValue.type)
      .getDisplayString()
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

String usedWrapperNameFromAnnotation(FieldElement field) {
  final annotation =
      TypeChecker.fromRuntime(UseClass).firstAnnotationOfExact(field);
  if (annotation == null) return null;
  final DartObject usedClass = annotation.getField('name');
  return usedClass?.toStringValue() ?? _defaultWrapper(field);
}

String _defaultWrapper(FieldElement field) {
  final usedClass = usedClassFromAnnotation(field);
  final usedClassType = usedClass.toTypeValue().getDisplayString();
  return '${usedClassType}Wrapper';
}
