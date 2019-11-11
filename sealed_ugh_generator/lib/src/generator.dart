import 'package:analyzer/dart/element/element.dart';
import 'package:sealed_ugh/sealed_ugh.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:code_builder/code_builder.dart';

import 'extension.dart';

//TODO : Improve specification of Data annotation and its fields parameter

Builder sealedUghGeneratorFactoryBuilder() => SharedPartBuilder(
      [SealedUghGenerator()],
      'sealed_ugh',
    );

final _dartFmt = DartFormatter();

TypeChecker _typeChecker(Type t) => TypeChecker.fromRuntime(t);

String _typeOfParameter(obj) =>
    ConstantReader(obj).read('type').typeValue.toString();

class SealedUghGenerator extends GeneratorForAnnotation<SealedUgh> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _dartFmt.format(_generateClass(element));
  }
}

String _generateClass(ClassElement element) {
  assert(element.isEnum);
  assert(element.isPrivate);

  bool isNamespaceGeneric =
      element.fields.any((e) => _typeChecker(Generic).hasAnnotationOfExact(e));

  final cls = Class((c) => c
    ..name = ('${element.name.replaceFirst('_', '')}')
    ..annotations.add(refer('immutable'))
    ..types.addAll(isNamespaceGeneric ? [refer('T')] : [])
    ..abstract = true
    ..fields.add(Field((f) => f
      ..name = '_type'
      ..modifier = FieldModifier.final$
      ..type = refer(element.name)
      ..build()))
    ..constructors.addAll(_generateClassConstructors(element))
    ..methods.add(_generateWhenMethod(element))
    ..build());
  final emitter = DartEmitter();
  return _dartFmt.format(
      '${cls.accept(emitter)}\n${_generateDerivedClasses(element).join('\n')}');
}

List<Constructor> _generateClassConstructors(ClassElement element) {
  assert(element.isEnum);
  assert(element.isPrivate);

  bool isNamespaceGeneric =
      element.fields.any((e) => _typeChecker(Generic).hasAnnotationOfExact(e));

  var classConstructors = [
    Constructor((constructor) => constructor
      ..constant = true
      ..requiredParameters.add(Parameter((p) => p
        ..name = 'this._type'
        ..build()))
      ..build())
  ];

  final fields = element.fields.skip(2);

  classConstructors.addAll(
    fields.map((field) => Constructor((constructor) => constructor
      ..factory = true
      ..name = '${getCamelCase(field.name)}'
      ..optionalParameters.addAll(_typeChecker(Data).hasAnnotationOfExact(field)
          ? _generateClassConstructorFields(field)
          : [])
      ..redirect = refer('${field.name}${isNamespaceGeneric ? '<T>' : ''}')
      ..build())),
  );

  return classConstructors;
}

Iterable<Parameter> _generateClassConstructorFields(FieldElement element) {
  final _annotation = _typeChecker(Data).firstAnnotationOfExact(element);
  final _fields = ConstantReader(_annotation).read('fields').listValue;

  return _fields.map((e) => Parameter((f) => f
    ..name = '${ConstantReader(e).read('name').stringValue}'
    ..type = _typeOfParameter(e) != "Generic"
        ? refer(_typeOfParameter(e))
        : refer('T')
    ..named = true
    ..annotations.add(refer('required'))
    ..build()));
}

/*
List<Field> _generateClassFields(ClassElement element) {
  assert(element.isEnum);
  assert(element.isPrivate);

  var classFields = [
    Field((f) => f
      ..name = '_type'
      ..modifier = FieldModifier.final$
      ..type = refer(element.name)
      ..build())
  ];

  final fields = element.fields.skip(2);

  classFields.addAll(
    fields
        .where((f) => _typeChecker(Object).hasAnnotationOfExact(f))
        .map((field) => Field((f) => f
          ..name = '${getCamelCase(field.name)}'
          ..static = true
          ..modifier = FieldModifier.constant
          ..assignment = Code('${field.name}()')
          ..build())),
  );

  return classFields;
}
*/

List<String> _generateDerivedClasses(ClassElement element) {
  assert(element.isEnum);
  assert(element.isPrivate);

  final fields = element.fields.skip(2);

  final List<String> classes = [];
  final DartEmitter emitter = DartEmitter();

  for (var field in fields) {
    if (_typeChecker(Object).hasAnnotationOfExact(field)) {
      classes.add(_dartFmt
          .format('${_generateObjectClass(field, element).accept(emitter)}'));
    } else if (_typeChecker(Data).hasAnnotationOfExact(field)) {
      classes.add(_dartFmt
          .format('${_generateDataClass(field, element).accept(emitter)}'));
    } else {
      //ignore other annotations
    }
  }

  return classes;
}

Method _generateWhenMethod(ClassElement element) {
  final fields = element.fields.skip(2);

  final List<Parameter> _params = [];

  final StringBuffer _bodyBuffer = StringBuffer();

  _bodyBuffer.writeln('switch(this._type){');

  for (var field in fields) {
    _bodyBuffer.writeln('case ${element.name}.${field.name}:');
    _bodyBuffer.writeln('return on${field.name}(this as ${field.name});');

    _params.add(Parameter((p) => p
      ..name = 'on${field.name}'
      ..named = true
      ..annotations.add(refer('required'))
      ..type = refer('R Function(${field.name})')
      ..build()));
  }

  _bodyBuffer.writeln('}');

  return Method((m) => m
    ..name = 'when'
    ..types.add(refer('R'))
    ..returns = refer('R')
    ..docs.add('//ignore: missing_return')
    ..optionalParameters.addAll(_params)
    ..body = Code(_bodyBuffer.toString())
    ..build());
}

Class _generateObjectClass(FieldElement field, ClassElement parent) {
  final isGeneric = _typeChecker(Generic).hasAnnotationOfExact(field);
  bool isNamespaceGeneric =
      parent.fields.any((e) => _typeChecker(Generic).hasAnnotationOfExact(e));

  if (isGeneric) throw 'Can\'t use @generic on object classes';

  return Class((c) => c
    ..name = '${field.name}'
    ..types.addAll(isNamespaceGeneric ? [refer('T')] : [])
    ..constructors.add(Constructor((c) => c
      ..constant = true
      ..initializers.add(Code('super(${parent.name}.${field.name})'))
      ..build()))
    ..extend = refer(
        '${parent.name.replaceFirst('_', '')}${isNamespaceGeneric ? '<T>' : ''}')
    ..annotations.add(refer('immutable'))
    ..build());
}

Class _generateDataClass(FieldElement field, ClassElement parent) {
  final annotation = _typeChecker(Data).firstAnnotationOfExact(field);
  final isGeneric = _typeChecker(Generic).hasAnnotationOfExact(field);
  bool isNamespaceGeneric =
      parent.fields.any((e) => _typeChecker(Generic).hasAnnotationOfExact(e));

  final _classFields =
      ConstantReader(annotation).read('fields')?.listValue ?? [];

  if (isGeneric) {
    if (_classFields.every((e) => _typeOfParameter(e) != "Generic")) {
      throw '${field.name} must have atleast one Generic field';
    }
  }

  if (_classFields.any((e) => _typeOfParameter(e) == "Generic")) {
    if (!isGeneric) throw '${field.name} must be annotated with @generic';
  }

  return Class((c) => c
    ..name = '${field.name}'
    ..extend = refer(
        '${parent.name.replaceFirst('_', '')}${isNamespaceGeneric ? '<T>' : ''}')
    ..annotations.add(refer('immutable'))
    ..types.addAll(isNamespaceGeneric ? [refer('T')] : [])
    ..fields.addAll(_classFields.map((e) => Field((f) => f
      ..name = ConstantReader(e).read('name').stringValue
      ..modifier = FieldModifier.final$
      ..type = _typeOfParameter(e) != "Generic"
          ? refer(_typeOfParameter(e))
          : refer('T')
      ..build())))
    ..constructors.add(Constructor((constructor) => constructor
      ..constant = true
      ..initializers.add(Code('super(${parent.name}.${field.name})'))
      ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) => f
        ..name = 'this.${ConstantReader(e).read('name').stringValue}'
        ..named = true
        ..annotations.add(refer('required'))
        ..build())))
      ..build()))
    ..build());
}
