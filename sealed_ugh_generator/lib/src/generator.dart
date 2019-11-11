import 'package:analyzer/dart/element/element.dart';
import 'package:sealed_ugh/sealed_ugh.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:code_builder/code_builder.dart';

//TODO : Improve specification of Data annotation and its fields parameter

Builder sealedUghGeneratorFactoryBuilder() => SharedPartBuilder(
      [SealedUghGenerator()],
      'sealed_ugh',
    );

final _dartFmt = DartFormatter();
TypeChecker _typeChecker(Type t) => TypeChecker.fromRuntime(t);

String _typeOfParameter(obj) => ConstantReader(obj).read('type').typeValue.toString();

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
  final isGeneric = _typeChecker(Generic).hasAnnotationOfExact(element);

  final cls = Class((c) => c
    ..name = ('${element.name.replaceFirst('_', '')}')
    ..annotations.add(refer('immutable'))
    ..types.addAll(isGeneric ? [refer('T')] : [])
    ..abstract = true
    ..fields.add(Field((f) => f
      ..name = '_type'
      ..modifier = FieldModifier.final$
      ..type = refer(element.name)
      ..build()))
    ..constructors.add(Constructor((constructor) => constructor
      ..constant = true
      ..requiredParameters.add(Parameter((p) => p
        ..name = 'this._type'
        ..build()))
      ..build()))
    ..methods.add(_generateWhenMethod(element))
    ..build());
  final emitter = DartEmitter();
  return _dartFmt.format(
      '${cls.accept(emitter)}\n${_generateDerivedClasses(element).join('\n')}');
}

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

  if(isGeneric)
    throw 'Can\'t use @generic on object classes';

  return Class((c) => c
  ..name = '${field.name}'
  ..constructors.add(Constructor((c) => c
    ..constant = true
    ..initializers.add(Code('super(${parent.name}.${field.name})'))
    ..build()))
  ..extend = refer(parent.name.replaceFirst('_', ''))
  ..annotations.add(refer('immutable'))
  ..build());
}

Class _generateDataClass(FieldElement field, ClassElement parent) {
  final annotation = _typeChecker(Data).firstAnnotationOfExact(field);
  final isGeneric = _typeChecker(Generic).hasAnnotationOfExact(field);

  final _classFields =
      ConstantReader(annotation).read('fields')?.listValue ?? [];


  if(isGeneric) {
    if(_classFields.every((e) => _typeOfParameter(e) != "Generic")){
      throw '${field.name} must have atleast one Generic field';
    }
  }

  if(_classFields.any((e) => _typeOfParameter(e) == "Generic")){
    if(!_typeChecker(Generic).hasAnnotationOfExact(parent))
      throw '${parent.name} must be annotated with @generic';
    if(!isGeneric)
      throw '${field.name} must be annotated with @generic';
  }

  return Class((c) => c
    ..name = '${field.name}'
    ..extend = refer(parent.name.replaceFirst('_', ''))
    ..annotations.add(refer('immutable'))
    ..types.addAll(isGeneric ? [refer('T')] : [])
    ..fields.addAll(_classFields.map((e) => Field((f) => f
      ..name = ConstantReader(e).read('name').stringValue
      ..modifier = FieldModifier.final$
      ..type =_typeOfParameter(e) != "Generic" ? refer(_typeOfParameter(e)) : refer('T')
      ..build())))
    // ..fields.add(Field((f) => f
    //   ..name = 'value'
    //   ..type = refer('T')
    //   ..modifier = FieldModifier.final$
    //   ..build()))
    ..constructors.add(Constructor((constructor) => constructor
      ..constant = true
      ..initializers.add(Code('super(${parent.name}.${field.name})'))
      // ..requiredParameters.add(Parameter((p) => p
      //   ..name = 'this.value'
      //   ..build()))

      ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) => f
        ..name = 'this.${ConstantReader(e).read('name').stringValue}'
        ..named = true
        ..annotations.add(refer('required'))
        ..build())))
      ..build()))
    ..build());
}
