import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';
import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/type_processor.dart' as type_processor;
import 'package:super_enum_generator/src/extension.dart';
import 'package:dart_style/dart_style.dart';
import 'package:super_enum_generator/src/references.dart' as references;

class ClassGenerator {
  final ClassElement element;

  const ClassGenerator(this.element);

  Iterable<FieldElement> get _fields => element.fields.skip(2);

  bool get _isNamespaceGeneric => _fields.any(type_processor.isGeneric);

  String generate(DartFormatter _dartFmt) {
    if (!element.isEnum || !element.isPrivate) {
      throw InvalidGenerationSourceError(
          '${element.name} must be a private Enum');
    }

    try {
      final cls = Class((c) => c
        ..name = ('${element.name.replaceFirst('_', '')}')
        ..annotations.add(references.immutable)
        ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
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
    } catch (e) {
      return "/*${e.stackTrace}*/";
    }
  }

  Method get _generateWhenMethod {
    final List<Parameter> _params = [];
    final StringBuffer _bodyBuffer = StringBuffer();

    _bodyBuffer.writeln('switch(this._type){');

    for (var field in _fields) {
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      _bodyBuffer.writeln(
          'return ${getCamelCase(field.name)}(this as ${field.name});');

      _params.add(Parameter((p) => p
        ..name = '${getCamelCase(field.name)}'
        ..named = true
        ..annotations.add(references.required)
        ..type = refer('R Function(${field.name})')
        ..build()));
    }

    _bodyBuffer.writeln('}');

    return Method((m) => m
      ..name = 'when'
      ..types.add(references.generic_R)
      //..annotations.add(References.protected)
      ..returns = references.generic_R
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
      ].followedBy(_fields.map((field) => Constructor((constructor) =>
          constructor
            ..factory = true
            ..name = '${getCamelCase(field.name)}'
            ..optionalParameters.addAll(
                type_processor.hasAnnotation<Data>(field)
                    ? _generateClassConstructorFields(field)
                    : [])
            ..redirect =
                refer('${field.name}${_isNamespaceGeneric ? '<T>' : ''}')
            ..build())));

  Iterable<Parameter> _generateClassConstructorFields(FieldElement element) {
    final fields = type_processor.listTypeFieldOf<Data>(element, 'fields');
    return fields.map((e) => Parameter((f) => f
      ..name = '${type_processor.dataFieldName(e)}'
      ..type = type_processor.dataFieldType(e) != "Generic"
          ? refer(type_processor.dataFieldType(e))
          : references.generic_T
      ..named = true
      ..annotations.add(references.required)
      ..build()));
  }

  String get _generateDerivedClasses => _fields
      .map((field) {
        if (type_processor.hasAnnotation<Object>(field)) {
          return '${_generateObjectClass(field).accept(DartEmitter())}';
        } else if (type_processor.hasAnnotation<Data>(field)) {
          if (type_processor.listTypeFieldOf<Data>(field, 'fields')?.isEmpty ??
              true) {
            throw InvalidGenerationSourceError(
                'Data annotation must contain at least one DataField');
          }
          return '${_generateDataClass(field).accept(DartEmitter())}';
        } else {
          return null;
        }
      })
      .where((e) => e != null)
      .join('');

  Class _generateObjectClass(FieldElement field) {
    final isGeneric = type_processor.isGeneric(field);

    if (isGeneric) {
      throw InvalidGenerationSourceError(
          'Can\'t use @generic on object classes');
    }

    return Class((c) => c
      ..name = '${field.name}'
      ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
      ..fields.add(Field((f) => f
        ..name = '_instance'
        ..static = true
        ..type = refer('${field.name}')
        ..build()))
      ..constructors.add(Constructor((c) => c
        ..constant = true
        ..name = '_'
        ..initializers.add(Code('super(${element.name}.${field.name})'))
        ..build()))
      ..constructors.add(Constructor((c) => c
        ..factory = true
        ..body = Code('''
        _instance ??= ${field.name}._();
        return _instance;
        ''')
        ..build()))
      ..extend = refer(
          '${element.name.replaceFirst('_', '')}${_isNamespaceGeneric ? '<T>' : ''}')
      ..annotations.add(references.immutable)
      ..build());
  }

  Class _generateDataClass(FieldElement field) {
    final _classFields = type_processor.listTypeFieldOf<Data>(field, 'fields');
    final isGeneric = type_processor.isGeneric(field);

    if (isGeneric) {
      if (_classFields
          .every((e) => type_processor.dataFieldType(e) != "Generic")) {
        throw InvalidGenerationSourceError(
            '${field.name} must have atleast one Generic field');
      }
    }

    if (_classFields.any((e) => type_processor.dataFieldType(e) == "Generic")) {
      if (!isGeneric) {
        throw InvalidGenerationSourceError(
            '${field.name} must be annotated with @generic');
      }
    }

    return Class((c) => c
      ..name = '${field.name}'
      ..extend = refer(
          '${element.name.replaceFirst('_', '')}${_isNamespaceGeneric ? '<T>' : ''}')
      ..annotations.add(references.immutable)
      ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
      ..fields.addAll(_classFields.map((e) => Field((f) => f
        ..name = type_processor.dataFieldName(e)
        ..modifier = FieldModifier.final$
        ..type = type_processor.dataFieldType(e) != "Generic"
            ? refer(type_processor.dataFieldType(e))
            : references.generic_T
        ..build())))
      ..constructors.add(Constructor((constructor) => constructor
        ..constant = true
        ..initializers.add(Code('super(${element.name}.${field.name})'))
        ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) => f
          ..name = 'this.${type_processor.dataFieldName(e)}'
          ..named = true
          ..annotations.add(references.required)
          ..build())))
        ..build()))
      ..build());
  }
}
