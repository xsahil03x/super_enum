import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/type_processor.dart' as TypeProcessor;
import 'package:super_enum_generator/src/extension.dart';
import 'package:dart_style/dart_style.dart';
import 'package:super_enum_generator/src/references.dart' as References;

class ClassGenerator {
  final ClassElement element;

  const ClassGenerator(this.element);

  Iterable<FieldElement> get _fields => element.fields.skip(2);

  bool get isNamespaceGeneric => _fields.any(TypeProcessor.isGeneric);

  String generate(DartFormatter _dartFmt) {
    assert(element.isEnum);
    assert(element.isPrivate);

    try {
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
      //..annotations.add(References.protected)
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
      ].followedBy(_fields.map((field) => Constructor((constructor) =>
          constructor
            ..factory = true
            ..name = '${getCamelCase(field.name)}'
            ..optionalParameters.addAll(TypeProcessor.hasAnnotation<Data>(field)
                ? _generateClassConstructorFields(field)
                : [])
            ..redirect =
                refer('${field.name}${isNamespaceGeneric ? '<T>' : ''}')
            ..build())));

  Iterable<Parameter> _generateClassConstructorFields(FieldElement element) {
    final fields = TypeProcessor.listTypeFieldOf<Data>(element, 'fields');
    return fields.map((e) => Parameter((f) => f
      ..name = '${TypeProcessor.dataFieldName(e)}'
      ..type = TypeProcessor.dataFieldType(e) != "Generic"
          ? refer(TypeProcessor.dataFieldType(e))
          : References.generic_T
      ..named = true
      ..annotations.add(References.required)
      ..build()));
  }

  String get _generateDerivedClasses => _fields
      .map((field) {
        if (TypeProcessor.hasAnnotation<Object>(field)) {
          return '${_generateObjectClass(field).accept(DartEmitter())}';
        } else if (TypeProcessor.hasAnnotation<Data>(field)) {
          return '${_generateDataClass(field).accept(DartEmitter())}';
        } else {
          return null;
        }
      })
      .where((e) => e != null)
      .join('');

  Class _generateObjectClass(FieldElement field) {
    final isGeneric = TypeProcessor.isGeneric(field);
    print('_generateObjectClass');

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
    final _classFields = TypeProcessor.listTypeFieldOf<Data>(field, 'fields');
    final isGeneric = TypeProcessor.isGeneric(field);

    if (isGeneric) {
      if (_classFields
          .every((e) => TypeProcessor.dataFieldType(e) != "Generic")) {
        throw '${field.name} must have atleast one Generic field';
      }
    }

    if (_classFields.any((e) => TypeProcessor.dataFieldType(e) == "Generic")) {
      if (!isGeneric) throw '${field.name} must be annotated with @generic';
    }

    return Class((c) => c
      ..name = '${field.name}'
      ..extend = refer(
          '${element.name.replaceFirst('_', '')}${isNamespaceGeneric ? '<T>' : ''}')
      ..annotations.add(References.immutable)
      ..types.addAll(isNamespaceGeneric ? [References.generic_T] : [])
      ..fields.addAll(_classFields.map((e) => Field((f) => f
        ..name = TypeProcessor.dataFieldName(e)
        ..modifier = FieldModifier.final$
        ..type = TypeProcessor.dataFieldType(e) != "Generic"
            ? refer(TypeProcessor.dataFieldType(e))
            : References.generic_T
        ..build())))
      ..constructors.add(Constructor((constructor) => constructor
        ..constant = true
        ..initializers.add(Code('super(${element.name}.${field.name})'))
        ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) => f
          ..name = 'this.${TypeProcessor.dataFieldName(e)}'
          ..named = true
          ..annotations.add(References.required)
          ..build())))
        ..build()))
      ..build());
  }
}
