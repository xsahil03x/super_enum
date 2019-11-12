import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:sealed_ugh/sealed_ugh.dart';
import 'package:sealed_ugh_generator/src/type_processor.dart';
import 'package:sealed_ugh_generator/src/extension.dart';
import 'package:source_gen/source_gen.dart';
import 'package:dart_style/dart_style.dart';
import 'package:sealed_ugh_generator/src/references.dart' as References;

class ClassGenerator {
  final ClassElement element;
  const ClassGenerator(this.element);

  List<FieldElement> get _fields => element.fields.skip(2);

  bool get isNamespaceGeneric => element.fields.any(
      (e) => TypeProcessor.typeChecker(Generic).hasAnnotationOfExact(e));

  String generate(DartFormatter _dartFmt) {
    assert(element.isEnum);
    assert(element.isPrivate);

    final cls = Class((c) => c
      ..name = ('${element.name.replaceFirst('_', '')}')
      ..annotations.add(References.immutable)
      ..types.addAll(isNamespaceGeneric ? [References.generic_T] : [])
      ..abstract = true
      ..fields.add(Field((f) => f
        ..name = '_type'
        ..modifier = FieldModifier.final$
        ..type = refer(element.name)
        ..build()))
      ..constructors.addAll(_generateClassConstructors)
      ..methods.add(_generateWhenMethod)
      ..build());
    final emitter = DartEmitter();
    return _dartFmt.format('${cls.accept(emitter)}$_generateDerivedClasses');
  }

  Method get _generateWhenMethod {

    final List<Parameter> _params = [];
    final StringBuffer _bodyBuffer = StringBuffer();

    _bodyBuffer.writeln('switch(this._type){');

    for (var field in _fields) {
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      _bodyBuffer.writeln('return on${field.name}(this as ${field.name});');

      _params.add(Parameter((p) => p
        ..name = 'on${field.name}'
        ..named = true
        ..annotations.add(References.required)
        ..type = refer('R Function(${field.name})')
        ..build()));
    }

    _bodyBuffer.writeln('}');

    return Method((m) => m
      ..name = 'when'
      ..types.add(References.generic_R)
      ..annotations.add(References.protected)
      ..returns = References.generic_R
      ..docs.add('//ignore: missing_return')
      ..optionalParameters.addAll(_params)
      ..body = Code(_bodyBuffer.toString())
      ..build());
  }

  Iterable<Constructor> get _generateClassConstructors => [
      Constructor((constructor) => constructor
        ..constant = true
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'this._type'
          ..build()))
        ..build()),
    ].followedBy(_fields.map((field) => Constructor((constructor) => constructor
      ..factory = true
      ..name = '${getCamelCase(field.name)}'
      ..optionalParameters.addAll(
          TypeProcessor.typeChecker(Data).hasAnnotationOfExact(field)
              ? _generateClassConstructorFields(field)
              : [])
      ..redirect = refer('${field.name}${isNamespaceGeneric ? '<T>' : ''}')
      ..build())));

  Iterable<Parameter> _generateClassConstructorFields(FieldElement element) {
    final _annotation =
        TypeProcessor.typeChecker(Data).firstAnnotationOfExact(element);
    final _fields = ConstantReader(_annotation).read('fields').listValue;

    return _fields.map((e) => Parameter((f) => f
      ..name = '${ConstantReader(e).read('name').stringValue}'
      ..type = TypeProcessor.typeOfParameter(e) != "Generic"
          ? refer(TypeProcessor.typeOfParameter(e))
          : References.generic_T
      ..named = true
      ..annotations.add(References.required)
      ..build()));
  }

  String get _generateDerivedClasses {
    final fields = element.fields.skip(2);
    final DartEmitter emitter = DartEmitter();
    return fields.map((field) {
      if (TypeProcessor.typeChecker(Object)
          .hasAnnotationOfExact(field)) {
        return '${_generateObjectClass(field).accept(emitter)}';
      } else if (TypeProcessor.typeChecker(Data)
          .hasAnnotationOfExact(field)) {
        return '${_generateDataClass(field).accept(emitter)}';
      } else {
        return null;
      }
    }).where((e) => e != null).join('');
  }

  Class _generateObjectClass(FieldElement field) {
    final isGeneric = TypeProcessor.typeChecker(Generic).hasAnnotationOfExact(field);

    if (isGeneric) throw 'Can\'t use @generic on object classes';

    return Class((c) => c
      ..name = '${field.name}'
      ..types.addAll(isNamespaceGeneric ? [References.generic_T] : [])
      ..constructors.add(Constructor((c) => c
        ..constant = true
        ..initializers.add(Code('super(${element.name}.${field.name})'))
        ..build()))
      ..extend = refer(
          '${element.name.replaceFirst('_', '')}${isNamespaceGeneric ? '<T>' : ''}')
      ..annotations.add(References.immutable)
      ..build());
  }

  Class _generateDataClass(FieldElement field) {
    final annotation = TypeProcessor.typeChecker(Data).firstAnnotationOfExact(field);
    final isGeneric = TypeProcessor.typeChecker(Generic).hasAnnotationOfExact(field);
   
    final _classFields =
        ConstantReader(annotation).read('fields')?.listValue ?? [];

    if (isGeneric) {
      if (_classFields.every((e) => TypeProcessor.typeOfParameter(e) != "Generic")) {
        throw '${field.name} must have atleast one Generic field';
      }
    }

    if (_classFields.any((e) => TypeProcessor.typeOfParameter(e) == "Generic")) {
      if (!isGeneric) throw '${field.name} must be annotated with @generic';
    }

    return Class((c) => c
      ..name = '${field.name}'
      ..extend = refer(
          '${element.name.replaceFirst('_', '')}${isNamespaceGeneric ? '<T>' : ''}')
      ..annotations.add(References.immutable)
      ..types.addAll(isNamespaceGeneric ? [References.generic_T] : [])
      ..fields.addAll(_classFields.map((e) => Field((f) => f
        ..name = ConstantReader(e).read('name').stringValue
        ..modifier = FieldModifier.final$
        ..type = TypeProcessor.typeOfParameter(e) != "Generic"
            ? refer(TypeProcessor.typeOfParameter(e))
            : References.generic_T
        ..build())))
      ..constructors.add(Constructor((constructor) => constructor
        ..constant = true
        ..initializers.add(Code('super(${element.name}.${field.name})'))
        ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) => f
          ..name = 'this.${ConstantReader(e).read('name').stringValue}'
          ..named = true
          ..annotations.add(References.required)
          ..build())))
        ..build()))
      ..build());
  }
}
