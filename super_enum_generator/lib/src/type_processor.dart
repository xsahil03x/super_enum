import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:super_enum/super_enum.dart';

enum PatternMatchingMethod { when, whenOrElse, whenPartial }

TypeChecker _typeChecker(Type t) => TypeChecker.fromRuntime(t);

String dataFieldName(DartObject obj) =>
    ConstantReader(obj).read('name').stringValue;

bool dataFieldRequired(DartObject obj) =>
    ConstantReader(obj).read('required').boolValue;

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
      .getDisplayString(withNullability: false)
      .replaceAll('Generic', 'T');
}

DartType _genericOf(DartType type) {
  return type is InterfaceType && type.typeArguments.isNotEmpty
      ? type.typeArguments.first
      : null;
}

List<String> docCommentsOf(Element element) {
  final comments = <String>[];
  if (element.documentationComment != null) {
    comments.add(element.documentationComment);
  }
  return comments;
}

List<String> copyWithDocComment(Element element) {
  final comments = <String>[];
  if (element != null) {
    comments.add(
      '/// Creates a copy of this ${element.name} but with the given fields\n'
      '/// replaced with the new values.',
    );
  }
  return comments;
}

List<String> patternMatchingMethodDocComment(
    PatternMatchingMethod method, Element element) {
  final comments = <String>[];
  if (method != null && element != null) {
    comments.add({
      PatternMatchingMethod.when:
          '/// The [when] method is the equivalent to pattern matching.\n'
              '/// Its prototype depends on the ${element.name} [_type]s defined.',
      PatternMatchingMethod.whenOrElse:
          "/// The [whenOrElse] method is equivalent to [when], but doesn't require\n"
              "/// all callbacks to be specified.\n"
              "///\n"
              "/// On the other hand, it adds an extra orElse required parameter,\n"
              "/// for fallback behavior.",
      PatternMatchingMethod.whenPartial:
          '/// The [whenPartial] method is equivalent to [whenOrElse],\n'
              '/// but non-exhaustive.',
    }[method]);
  }
  return comments;
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
  final usedClassType =
      usedClass.toTypeValue().getDisplayString(withNullability: false);
  return '${usedClassType}Wrapper';
}
