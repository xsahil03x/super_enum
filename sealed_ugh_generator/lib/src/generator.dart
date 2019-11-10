import 'package:analyzer/dart/element/element.dart';
import 'package:sealed_ugh/sealed_ugh.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:code_builder/code_builder.dart';

//TODO : Allow for fields to be put into the Data class specified as paramters to Data annotation.

Builder sealedUghGeneratorFactoryBuilder() => SharedPartBuilder(
      [SealedUghGenerator()],
      'sealed_ugh',
    );

final _dartFmt = DartFormatter();
TypeChecker _typeChecker(Type t) => TypeChecker.fromRuntime(t);

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
  final cls = Class((c) => c
    ..name = ('${element.name.replaceFirst('_', '')}')
    ..types.add(refer('T'))
    ..abstract = true
    ..fields.add(Field((f) => f
      ..name = '_type'
      ..modifier = FieldModifier.final$
      ..type = refer(element.name)
      ..build()))
    ..constructors.add(Constructor((constructor) => constructor
      ..requiredParameters.add(Parameter((p) => p
        ..name = 'this._type'
        ..build()))
      ..build()))
    ..methods.add(_generateWhenMethod(element))
    ..build());
  final emitter = DartEmitter();
  return _dartFmt.format(
      '${cls.accept(emitter)}\n${_generateDerivedClasses(element, cls.name).join('\n')}');
}

List<String> _generateDerivedClasses(ClassElement element, String parent) {
  assert(element.isEnum);
  assert(element.isPrivate);

  final fields = element.fields.skip(2);

  final List<String> classes = [];
  final DartEmitter emitter = DartEmitter();

  for (var field in fields) {
    if (_typeChecker(Object).hasAnnotationOfExact(field)) {
      classes.add('${_generateObjectClass(field, parent).accept(emitter)}');
    } else if (_typeChecker(Data).hasAnnotationOfExact(field)) {
      classes.add('${_generateDataClass(field, parent).accept(emitter)}');
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

Class _generateObjectClass(FieldElement field, String parent) => Class((c) => c
  ..name = '${field.name}'
  ..types.add(refer('T'))
  ..constructors.add(Constructor((c) => c
    ..initializers.add(Code('super(_$parent.${field.name})'))
    ..build()))
  ..extend = refer(parent)
  ..build());

Class _generateDataClass(FieldElement field, String parent) => Class((c) => c
  ..name = '${field.name}'
  ..extend = refer(parent)
  ..types.add(refer('T'))
  ..fields.add(Field((f) => f
    ..name = 'value'
    ..type = refer('T')
    ..modifier = FieldModifier.final$
    ..build()))
  ..constructors.add(Constructor((constructor) => constructor
    ..initializers.add(Code('super(_$parent.${field.name})'))
    ..requiredParameters.add(Parameter((p) => p
      ..name = 'this.value'
      ..build()))
    ..build()))
  ..build());
