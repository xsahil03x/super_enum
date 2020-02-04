import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/extension.dart';
import 'package:super_enum_generator/src/references.dart' as references;
import 'package:super_enum_generator/src/type_processor.dart' as type_processor;

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
        ..extend = references.equatable
        ..fields.add(Field((f) => f
          ..name = '_type'
          ..modifier = FieldModifier.final$
          ..type = refer(element.name)
          ..build()))
        ..constructors.addAll(_generateClassConstructors)
        ..methods.add(_generateWhenMethod)
        ..methods.add(_generateWhenOrElseMethod)
        ..methods.add(_generateWhenPartialMethod)
        ..methods.add(Method((m) {
          return m
            ..name = 'props'
            ..lambda = true
            ..returns = references.dynamic_list
            ..annotations.add(references.override)
            ..type = MethodType.getter
            ..body = Code('const []')
            ..build();
        }))
        ..build());

      final emitter = DartEmitter();
      return _dartFmt.format('${cls.accept(emitter)}$_generateDerivedClasses');
    } catch (e, stackTrace) {
      return "/*$e*/";
    }
  }

  Method get _generateWhenMethod {
    final List<Parameter> _params = [];
    final StringBuffer _bodyBuffer = StringBuffer();

    final assertionCondition =
        _fields.map((f) => '${getCamelCase(f.name)} == null').join(' || ');

    _bodyBuffer.write(
      "assert(() {"
      "if ($assertionCondition) {throw 'check for all possible cases';}"
      "return true;"
      "}());",
    );

    _bodyBuffer.writeln('switch(this._type){');

    for (var field in _fields) {
      final DartObject usedClass =
          type_processor.usedClassFromAnnotation(field);
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      if (usedClass != null) {
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '((this as ${usedClass.toTypeValue().name}Wrapper)'
            '.${getCamelCase(usedClass.toTypeValue().name)});');
      } else {
        _bodyBuffer.writeln(
            'return ${getCamelCase(field.name)}(this as ${field.name});');
      }

      final callbackArgType = usedClass != null
          ? '${usedClass.toTypeValue().name}'
          : '${field.name}';
      _params.add(Parameter((p) {
        return p
          ..name = '${getCamelCase(field.name)}'
          ..named = true
          ..annotations.add(references.required)
          ..type = refer(
            'FutureOr<R> Function('
            '${_isNamespaceGeneric ? '${callbackArgType}<T>' : callbackArgType}'
            ')',
          )
          ..build();
      }));
    }

    _bodyBuffer.writeln('}');

    return Method((m) => m
      ..name = 'when'
      ..types.add(references.generic_R)
      ..returns = references.futureOr_Generic_R
      ..docs.add('//ignore: missing_return')
      ..optionalParameters.addAll(_params)
      ..body = Code(_bodyBuffer.toString())
      ..build());
  }

  Method get _generateWhenOrElseMethod {
    final List<Parameter> _params = [];
    final StringBuffer _bodyBuffer = StringBuffer();

    _bodyBuffer.write(
      "assert(() {"
      "if (orElse == null) {throw 'Missing orElse case';}"
      "return true;"
      "}());",
    );

    _bodyBuffer.writeln('switch(this._type){');

    for (var field in _fields) {
      final DartObject usedClass =
          type_processor.usedClassFromAnnotation(field);
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      _bodyBuffer.writeln('if (${getCamelCase(field.name)} == null) break;');
      if (usedClass != null) {
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '((this as ${usedClass.toTypeValue().name}Wrapper)'
            '.${getCamelCase(usedClass.toTypeValue().name)});');
      } else {
        _bodyBuffer.writeln(
            'return ${getCamelCase(field.name)}(this as ${field.name});');
      }

      final callbackArgType = usedClass != null
          ? '${usedClass.toTypeValue().name}'
          : '${field.name}';
      _params.add(Parameter((p) => p
        ..name = '${getCamelCase(field.name)}'
        ..named = true
        ..type = refer(
          'FutureOr<R> Function('
          '${_isNamespaceGeneric ? '${callbackArgType}<T>' : callbackArgType}'
          ')',
        )
        ..build()));
    }

    _params.add(Parameter((p) => p
      ..name = 'orElse'
      ..named = true
      ..annotations.add(references.required)
      ..type = refer(
        'FutureOr<R> Function('
        '${_isNamespaceGeneric ? '${element.name.replaceFirst('_', '')}<T>' : element.name.replaceFirst('_', '')}'
        ')',
      )
      ..build()));

    _bodyBuffer.write(
      '}'
      'return orElse(this);',
    );

    return Method((m) => m
      ..name = 'whenOrElse'
      ..types.add(references.generic_R)
      ..returns = references.futureOr_Generic_R
      ..optionalParameters.addAll(_params)
      ..body = Code(_bodyBuffer.toString())
      ..build());
  }

  Method get _generateWhenPartialMethod {
    final List<Parameter> _params = [];
    final StringBuffer _bodyBuffer = StringBuffer();

    final assertionCondition =
        _fields.map((f) => '${getCamelCase(f.name)} == null').join(' && ');

    _bodyBuffer.write(
      "assert(() {"
      "if ($assertionCondition){ throw 'provide at least one branch';}"
      "return true;"
      "}());",
    );

    _bodyBuffer.writeln('switch(this._type){');

    for (var field in _fields) {
      final DartObject usedClass =
          type_processor.usedClassFromAnnotation(field);
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      _bodyBuffer.writeln('if (${getCamelCase(field.name)} == null) break;');
      if (usedClass != null) {
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '((this as ${usedClass.toTypeValue().name}Wrapper)'
            '.${getCamelCase(usedClass.toTypeValue().name)});');
      } else {
        _bodyBuffer.writeln(
            'return ${getCamelCase(field.name)}(this as ${field.name});');
      }

      final callbackArgType = usedClass != null
          ? '${usedClass.toTypeValue().name}'
          : '${field.name}';
      _params.add(Parameter((p) => p
        ..name = '${getCamelCase(field.name)}'
        ..named = true
        ..type = refer(
          'FutureOr<void> Function('
          '${_isNamespaceGeneric ? '${callbackArgType}<T>' : callbackArgType}'
          ')',
        )
        ..build()));
    }

    _bodyBuffer.writeln('}');

    return Method((m) => m
      ..name = 'whenPartial'
      ..returns = references.futureOr
      ..optionalParameters.addAll(_params)
      ..body = Code(_bodyBuffer.toString())
      ..build());
  }

  Iterable<Constructor> get _generateClassConstructors {
    final defaultConstructor = Constructor((constructor) => constructor
      ..constant = true
      ..requiredParameters.add(Parameter((p) => p
        ..name = 'this._type'
        ..build()))
      ..build());
    final fieldConstructors = _fields.map((field) {
      final annotation =
          TypeChecker.fromRuntime(UseClass).firstAnnotationOfExact(field);
      var redirectConstructorName =
          '${field.name}${_isNamespaceGeneric ? '<T>' : ''}';
      final reqParams = <Parameter>[];
      if (annotation != null) {
        final DartObject usedClass = annotation.getField('type');
        redirectConstructorName = "${usedClass.toTypeValue().name}Wrapper";
        reqParams.add(Parameter((p) => p
          ..name = '${getCamelCase(usedClass.toTypeValue().name)}'
          ..type = Reference(usedClass.toTypeValue().name)
          ..build()));
      }
      return Constructor((constructor) => constructor
        ..factory = true
        ..name = '${getCamelCase(field.name)}'
        ..optionalParameters.addAll(type_processor.hasAnnotation<Data>(field)
            ? _generateClassConstructorFields(field)
            : [])
        ..requiredParameters.addAll(reqParams)
        ..redirect = refer(redirectConstructorName)
        ..build());
    });
    return [defaultConstructor].followedBy(fieldConstructors);
  }

  Iterable<Parameter> _generateClassConstructorFields(FieldElement element) {
    final fields = type_processor.listTypeFieldOf<Data>(element, 'fields');
    return fields.map((e) => Parameter((f) => f
      ..name = '${type_processor.dataFieldName(e)}'
      ..type = refer(type_processor.dataFieldType(e))
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
        } else if (type_processor.hasAnnotation<UseClass>(field)) {
          return '${_generateClassWrapper(field).accept(DartEmitter())}';
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

    Method toString = Method((m) {
      final String values = _classFields
          .map((f) =>
              '${type_processor.dataFieldName(f)}:\${this.${type_processor.dataFieldName(f)}}')
          .join(',');
      return m
        ..name = 'toString'
        ..lambda = true
        ..annotations.add(references.override)
        ..body = Code("'${field.name}($values)'")
        ..returns = references.string
        ..build();
    });

    Method getProps = Method((m) {
      final String values = _classFields
          .map((f) => '${type_processor.dataFieldName(f)}')
          .join(',');
      return m
        ..name = 'props'
        ..lambda = true
        ..returns = references.dynamic_list
        ..annotations.add(references.override)
        ..type = MethodType.getter
        ..body = Code('[$values]')
        ..build();
    });

    if (isGeneric) {
      if (_classFields
          .every((e) => !type_processor.dataFieldType(e).contains('T'))) {
        throw InvalidGenerationSourceError(
            '${field.name} must have atleast one Generic field');
      }
    }

    if (_classFields
        .any((e) => type_processor.dataFieldType(e).contains('T'))) {
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
      ..methods.addAll([toString, getProps])
      ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
      ..fields.addAll(_classFields.map((e) => Field((f) => f
        ..name = type_processor.dataFieldName(e)
        ..modifier = FieldModifier.final$
        ..type = refer(type_processor.dataFieldType(e))
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

  Class _generateClassWrapper(FieldElement field) {
    final usedClass = type_processor.usedClassFromAnnotation(field);
    final usedClassType = usedClass.toTypeValue().name;

    Method toString = Method((m) {
      return m
        ..name = 'toString'
        ..lambda = true
        ..annotations.add(references.override)
        ..body =
            Code("'${usedClassType}Wrapper(\$${getCamelCase(usedClassType)})'")
        ..returns = references.string
        ..build();
    });

    Method getProps = Method((m) {
      return m
        ..name = 'props'
        ..lambda = true
        ..returns = references.dynamic_list
        ..annotations.add(references.override)
        ..type = MethodType.getter
        ..body = Code('[${getCamelCase(usedClassType)}]')
        ..build();
    });

    return Class((c) => c
      ..name = '${usedClassType}Wrapper'
      ..annotations.add(references.immutable)
      ..fields.add(Field((f) {
        return f
          ..name = getCamelCase(usedClass.toTypeValue().name)
          ..modifier = FieldModifier.final$
          ..type = Reference(usedClass.toTypeValue().name);
      }))
      ..methods.addAll([toString, getProps])
      ..extend = refer('${element.name.replaceFirst('_', '')}')
      ..constructors.add(Constructor((constructor) {
        return constructor
          ..constant = true
          ..initializers.add(Code('super(${element.name}.${field.name})'))
          ..requiredParameters.add(
            Parameter((p) => p
              ..name = "this.${getCamelCase(usedClassType)}"
              ..named = false
              ..build()),
          );
      }))
      ..build());
  }
}
