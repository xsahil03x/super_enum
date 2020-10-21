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

  ClassGenerator(this.element);

  Iterable<FieldElement> get _fields => element.fields.skip(2);

  bool get _isNamespaceGeneric => _fields.any(type_processor.isGeneric);

  final Set<String> wrapper = {};

  String generate(DartFormatter _dartFmt) {
    if (!element.isEnum || !element.isPrivate) {
      throw InvalidGenerationSourceError(
          '${element.name} must be a private Enum');
    }

    try {
      final cls = Class((c) => c
        ..name = ('${element.name.replaceFirst('_', '')}')
        ..annotations.add(references.immutable)
        ..docs.addAll(type_processor.docCommentsOf(element))
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
            ..returns = references.object_list
            ..annotations.add(references.override)
            ..type = MethodType.getter
            ..body = Code('const []')
            ..build();
        }))
        ..build());

      final emitter = DartEmitter();
      return _dartFmt.format('${cls.accept(emitter)}$_generateDerivedClasses');
    } catch (e, _) {
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
      final hasObjectAnnotation =
          type_processor.hasAnnotation<ObjectClass>(field);
      final DartObject usedClass =
          type_processor.usedClassFromAnnotation(field);
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      if (usedClass != null) {
        final wrapperName = type_processor.usedWrapperNameFromAnnotation(field);
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '((this as $wrapperName)'
            '.${getCamelCase(usedClass.toTypeValue().getDisplayString(withNullability: false))});');
      } else {
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '${hasObjectAnnotation ? '()' : '(this as ${field.name})'};');
      }

      final callbackArgType = usedClass != null
          ? '${usedClass.toTypeValue().getDisplayString(withNullability: false)}'
          : '${field.name}';
      _params.add(Parameter((p) {
        return p
          ..name = '${getCamelCase(field.name)}'
          ..named = true
          ..annotations.add(references.required)
          ..type = refer(
            '${references.generic_R.symbol} Function('
            '${hasObjectAnnotation ? '' : '${_isNamespaceGeneric ? '$callbackArgType<T>' : callbackArgType}'}'
            ')',
          )
          ..build();
      }));
    }

    _bodyBuffer.writeln('}');

    return Method((m) => m
      ..name = 'when'
      ..docs.addAll(type_processor.patternMatchingMethodDocComment(
        type_processor.PatternMatchingMethod.when,
        element,
      ))
      ..types.add(references.generic_R_extends_Object)
      ..returns = references.generic_R
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
      final hasObjectAnnotation =
          type_processor.hasAnnotation<ObjectClass>(field);
      final DartObject usedClass =
          type_processor.usedClassFromAnnotation(field);
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      _bodyBuffer.writeln('if (${getCamelCase(field.name)} == null) break;');
      if (usedClass != null) {
        final wrapperName = type_processor.usedWrapperNameFromAnnotation(field);
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '((this as $wrapperName)'
            '.${getCamelCase(usedClass.toTypeValue().getDisplayString(withNullability: false))});');
      } else {
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '${hasObjectAnnotation ? '()' : '(this as ${field.name})'};');
      }

      final callbackArgType = usedClass != null
          ? '${usedClass.toTypeValue().getDisplayString(withNullability: false)}'
          : '${field.name}';
      _params.add(Parameter((p) => p
        ..name = '${getCamelCase(field.name)}'
        ..named = true
        ..type = refer(
          '${references.generic_R.symbol} Function('
          '${hasObjectAnnotation ? '' : '${_isNamespaceGeneric ? '$callbackArgType<T>' : callbackArgType}'}'
          ')',
        )
        ..build()));
    }

    _params.add(Parameter((p) => p
      ..name = 'orElse'
      ..named = true
      ..annotations.add(references.required)
      ..type = refer(
        '${references.generic_R.symbol} Function('
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
      ..docs.addAll(type_processor.patternMatchingMethodDocComment(
        type_processor.PatternMatchingMethod.whenOrElse,
        element,
      ))
      ..types.add(references.generic_R_extends_Object)
      ..returns = references.generic_R
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
      final hasObjectAnnotation =
          type_processor.hasAnnotation<ObjectClass>(field);
      final DartObject usedClass =
          type_processor.usedClassFromAnnotation(field);
      _bodyBuffer.writeln('case ${element.name}.${field.name}:');
      _bodyBuffer.writeln('if (${getCamelCase(field.name)} == null) break;');
      if (usedClass != null) {
        final wrapperName = type_processor.usedWrapperNameFromAnnotation(field);
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '((this as $wrapperName)'
            '.${getCamelCase(usedClass.toTypeValue().getDisplayString(withNullability: false))});');
      } else {
        _bodyBuffer.writeln('return ${getCamelCase(field.name)}'
            '${hasObjectAnnotation ? '()' : '(this as ${field.name})'};');
      }

      final callbackArgType = usedClass != null
          ? '${usedClass.toTypeValue().getDisplayString(withNullability: false)}'
          : '${field.name}';
      _params.add(Parameter((p) => p
        ..name = '${getCamelCase(field.name)}'
        ..named = true
        ..type = refer(
          '${references.ref_void.symbol} Function('
          '${hasObjectAnnotation ? '' : '${_isNamespaceGeneric ? '$callbackArgType<T>' : callbackArgType}'}'
          ')',
        )
        ..build()));
    }

    _bodyBuffer.writeln('}');

    return Method((m) => m
      ..name = 'whenPartial'
      ..docs.addAll(type_processor.patternMatchingMethodDocComment(
        type_processor.PatternMatchingMethod.whenPartial,
        element,
      ))
      ..returns = references.ref_void
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
        redirectConstructorName =
            type_processor.usedWrapperNameFromAnnotation(field);
        reqParams.add(Parameter((p) => p
          ..name =
              '${getCamelCase(usedClass.toTypeValue().getDisplayString(withNullability: false))}'
          ..type = Reference(
              usedClass.toTypeValue().getDisplayString(withNullability: false))
          ..build()));
      }
      return Constructor((constructor) => constructor
        ..factory = true
        ..name = '${getCamelCase(field.name)}'
        ..docs.addAll(type_processor.docCommentsOf(field))
        ..optionalParameters.addAll(type_processor.hasAnnotation<Data>(field)
            ? _generateClassConstructorFields(field)
            : [])
        ..requiredParameters.addAll(reqParams)
        ..redirect = refer(type_processor.hasAnnotation<UseClass>(field)
            ? '$redirectConstructorName'
            : '$redirectConstructorName.create')
        ..build());
    });
    return [defaultConstructor].followedBy(fieldConstructors);
  }

  Iterable<Parameter> _generateClassConstructorFields(FieldElement element) {
    final fields = type_processor.listTypeFieldOf<Data>(element, 'fields');
    return fields.map((e) => Parameter((f) {
          if (type_processor.dataFieldRequired(e)) {
            f.annotations.add(references.required);
          }
          return f
            ..name = '${type_processor.dataFieldName(e)}'
            ..type = refer(type_processor.dataFieldType(e))
            ..named = true
            ..build();
        }));
  }

  String get _generateDerivedClasses => _fields
      .map((field) {
        if (type_processor.hasAnnotation<ObjectClass>(field)) {
          return '${_generateObjectClass(field).accept(DartEmitter())}';
        } else if (type_processor.hasAnnotation<Data>(field)) {
          if (type_processor.listTypeFieldOf<Data>(field, 'fields')?.isEmpty ??
              true) {
            throw InvalidGenerationSourceError(
                'Data annotation must contain at least one DataField');
          }
          return '${_generateDataClass(field).accept(DartEmitter())}';
        } else if (type_processor.hasAnnotation<UseClass>(field)) {
          final clazz = _generateClassWrapper(field);
          if (clazz == null) return null;
          return '${clazz.accept(DartEmitter())}';
        } else {
          return null;
        }
      })
      .where((e) => e != null)
      .join('');

  ImplementedClass _generateObjectClass(FieldElement field) {
    final isGeneric = type_processor.isGeneric(field);

    if (isGeneric) {
      throw InvalidGenerationSourceError(
          'Can\'t use @generic on object classes');
    }

    final Method toString = Method((m) => m
      ..name = 'toString'
      ..lambda = true
      ..annotations.add(references.override)
      ..body = Code("'${field.name}()'")
      ..returns = references.string
      ..build());

    final _objectClass = Class((c) => c
      ..name = '${field.name}'
      ..abstract = true
      ..docs.addAll(type_processor.docCommentsOf(field))
      ..extend = refer(
          '${element.name.replaceFirst('_', '')}${_isNamespaceGeneric ? '<T>' : ''}')
      ..annotations.add(references.immutable)
      ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
      ..constructors.addAll([
        Constructor((c) => c
          ..constant = true
          ..initializers.add(Code('super(${element.name}.${field.name})'))
          ..build()),
        Constructor((c) => c
          ..name = 'create'
          ..factory = true
          ..docs.addAll(type_processor.docCommentsOf(field))
          ..redirect =
              refer('_${field.name}Impl${_isNamespaceGeneric ? '<T>' : ''}')
          ..build())
      ])
      ..build());

    final _objectClassImpl = Class((c) => c
      ..name = '_${field.name}Impl'
      ..extend = refer('${field.name}${_isNamespaceGeneric ? '<T>' : ''}')
      ..annotations.add(references.immutable)
      ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
      ..methods.add(toString)
      ..constructors.add(Constructor((c) => c
        ..constant = true
        ..initializers.add(const Code('super()'))
        ..build()))
      ..build());

    return ImplementedClass(
      abstractClass: _objectClass,
      abstractClassImpl: _objectClassImpl,
    );
  }

  ImplementedClass _generateDataClass(FieldElement field) {
    final _classFields = type_processor.listTypeFieldOf<Data>(field, 'fields');
    final isGeneric = type_processor.isGeneric(field);

    final Method toString = Method((m) {
      final String values = _classFields
          .map((f) =>
              '${type_processor.dataFieldName(f)}: \${this.${type_processor.dataFieldName(f)}}')
          .join(', ');
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
        ..returns = references.object_list
        ..annotations.add(references.override)
        ..type = MethodType.getter
        ..body = Code('[$values]')
        ..build();
    });

    Method copyWith = Method((m) => m
      ..name = 'copyWith'
      ..docs.addAll(type_processor.copyWithDocComment(field))
      ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) => f
        ..name = type_processor.dataFieldName(e)
        ..type = Reference(type_processor.dataFieldType(e))
        ..named = true
        ..build())))
      ..returns = Reference('${field.name}${_isNamespaceGeneric ? '<T>' : ''}')
      ..build());

    final Method copyWithImpl = Method((m) {
      final String values = _classFields.map((e) {
        final dataFieldName = type_processor.dataFieldName(e);
        final dataFieldType = type_processor.dataFieldType(e);
        var value =
            '$dataFieldName: $dataFieldName == superEnum ? this.$dataFieldName : $dataFieldName';
        if (dataFieldType != 'Object') {
          value = '$value as $dataFieldType';
        }
        return '$value,';
      }).join();
      return m
        ..name = 'copyWith'
        ..lambda = true
        ..annotations.add(references.override)
        ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) => f
          ..name = type_processor.dataFieldName(e)
          ..type = const Reference('Object')
          ..defaultTo = const Code('superEnum')
          ..named = true
          ..build())))
        ..returns =
            Reference('_${field.name}Impl${_isNamespaceGeneric ? '<T>' : ''}')
        ..body = Code("_${field.name}Impl($values)")
        ..build();
    });

    if (isGeneric) {
      if (_classFields
          .where((e) =>
              type_processor.dataFieldType(e).contains('<T>') ||
              type_processor.dataFieldType(e) == 'T')
          .isEmpty) {
        throw InvalidGenerationSourceError(
            '${field.name} must have atleast one Generic field');
      }
    }

    if (_classFields.any((e) =>
        type_processor.dataFieldType(e).contains('<T>') ||
        type_processor.dataFieldType(e) == 'T')) {
      if (!isGeneric) {
        throw InvalidGenerationSourceError(
            '${field.name} must be annotated with @generic');
      }
    }

    final _dataClass = Class((c) => c
      ..name = '${field.name}'
      ..extend = refer(
          '${element.name.replaceFirst('_', '')}${_isNamespaceGeneric ? '<T>' : ''}')
      ..abstract = true
      ..docs.addAll(type_processor.docCommentsOf(field))
      ..annotations.add(references.immutable)
      ..methods.add(copyWith)
      ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
      ..fields.addAll(_classFields.map((e) => Field((f) => f
        ..name = type_processor.dataFieldName(e)
        ..modifier = FieldModifier.final$
        ..type = refer(type_processor.dataFieldType(e))
        ..build())))
      ..constructors.addAll([
        Constructor((c) => c
          ..constant = true
          ..initializers.add(Code('super(${element.name}.${field.name})'))
          ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) {
                if (type_processor.dataFieldRequired(e)) {
                  f.annotations.add(references.required);
                }
                return f
                  ..name = 'this.${type_processor.dataFieldName(e)}'
                  ..named = true
                  ..build();
              })))
          ..build()),
        Constructor((c) => c
          ..name = 'create'
          ..factory = true
          ..docs.addAll(type_processor.docCommentsOf(field))
          ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) {
                if (type_processor.dataFieldRequired(e)) {
                  f.annotations.add(references.required);
                }
                return f
                  ..name =
                      '${type_processor.dataFieldType(e)} ${type_processor.dataFieldName(e)}'
                  ..named = true
                  ..build();
              })))
          ..redirect =
              refer('_${field.name}Impl${_isNamespaceGeneric ? '<T>' : ''}')
          ..build())
      ])
      ..build());

    final _dataClassImpl = Class((c) {
      final String values = _classFields.map((e) {
        final dataFieldName = type_processor.dataFieldName(e);
        return '$dataFieldName: $dataFieldName';
      }).join(', ');
      return c
        ..name = '_${field.name}Impl'
        ..extend = refer('${field.name}${_isNamespaceGeneric ? '<T>' : ''}')
        ..annotations.add(references.immutable)
        ..methods.addAll([copyWithImpl, toString, getProps])
        ..types.addAll(_isNamespaceGeneric ? [references.generic_T] : [])
        ..fields.addAll(_classFields.map((e) => Field((f) => f
          ..name = type_processor.dataFieldName(e)
          ..modifier = FieldModifier.final$
          ..annotations.add(references.override)
          ..type = refer(type_processor.dataFieldType(e))
          ..build())))
        ..constructors.add(Constructor((constructor) => constructor
          ..constant = true
          ..initializers.add(Code('super($values)'))
          ..optionalParameters.addAll(_classFields.map((e) => Parameter((f) {
                if (type_processor.dataFieldRequired(e)) {
                  f.annotations.add(references.required);
                }
                return f
                  ..name = 'this.${type_processor.dataFieldName(e)}'
                  ..named = true
                  ..build();
              })))
          ..build()))
        ..build();
    });

    return ImplementedClass(
      abstractClass: _dataClass,
      abstractClassImpl: _dataClassImpl,
    );
  }

  Class _generateClassWrapper(FieldElement field) {
    final usedClass = type_processor.usedClassFromAnnotation(field);
    final usedClassType =
        usedClass.toTypeValue().getDisplayString(withNullability: false);
    final wrapperName = type_processor.usedWrapperNameFromAnnotation(field);
    if (wrapper.contains(wrapperName)) {
      // Skip wrapper generation, wrapper already exists
      return null;
    } else {
      wrapper.add(wrapperName);
    }

    Method toString = Method((m) => m
      ..name = 'toString'
      ..lambda = true
      ..annotations.add(references.override)
      ..body = Code("'$wrapperName(\$${getCamelCase(usedClassType)})'")
      ..returns = references.string
      ..build());

    Method getProps = Method((m) => m
      ..name = 'props'
      ..lambda = true
      ..returns = references.object_list
      ..annotations.add(references.override)
      ..type = MethodType.getter
      ..body = Code('[${getCamelCase(usedClassType)}]')
      ..build());

    return Class((c) => c
      ..name = wrapperName
      ..annotations.add(references.immutable)
      ..fields.add(Field((f) => f
        ..name = getCamelCase(
            usedClass.toTypeValue().getDisplayString(withNullability: false))
        ..modifier = FieldModifier.final$
        ..type = Reference(
            usedClass.toTypeValue().getDisplayString(withNullability: false))))
      ..methods.addAll([toString, getProps])
      ..extend = refer('${element.name.replaceFirst('_', '')}')
      ..constructors.add(Constructor((constructor) => constructor
        ..constant = true
        ..initializers.add(Code('super(${element.name}.${field.name})'))
        ..requiredParameters.add(
          Parameter((p) => p
            ..name = "this.${getCamelCase(usedClassType)}"
            ..named = false
            ..build()),
        )))
      ..build());
  }
}

@immutable
class ImplementedClass {
  final Class abstractClass;
  final Class abstractClassImpl;

  const ImplementedClass({
    @required this.abstractClass,
    @required this.abstractClassImpl,
  });

  String accept(DartEmitter dartEmitter) =>
      '${abstractClass.accept(dartEmitter)}'
      '${abstractClassImpl.accept(dartEmitter)}';
}
