import 'package:analyzer/dart/element/element.dart';
import 'package:sealed_ugh/sealed_ugh.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:code_builder/code_builder.dart';

Builder sealedUghGeneratorFactoryBuilder() => SharedPartBuilder(
      [SealedUghGenerator()],
      'sealed_ugh',
    );

final _dartFmt = DartFormatter();

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
    ..name = ('${element.name.replaceFirst('_', '')}<T>')
    ..abstract = true
    ..build());
  final emitter = DartEmitter();
  return _dartFmt.format('${cls.accept(emitter)}\n${_generateDerivedClasses(element).join('\n')}');
}

List<String> _generateDerivedClasses(ClassElement element) {
  assert(element.isEnum);
  assert(element.isPrivate);

  final fields = element.fields.skip(2);

  final List<String> classes = [];
  final emitter = DartEmitter();

  for(var field in fields){
      final cls = Class(
      (c) => c..name = '${field.name}<T>'..extend = refer('${element.name.replaceFirst('_', '')}<T>')..build()
      );
      classes.add(
        '${cls.accept(emitter)}'
      );

  }

  return classes;
}
