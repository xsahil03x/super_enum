import 'package:analyzer/dart/element/element.dart';
import 'package:sealed_ugh/sealed_ugh.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

Builder sealedUghGeneratorFactoryBuilder() => SharedPartBuilder(
      [SealedUghGenerator()],
      'sealed_ugh',
    );

class SealedUghGenerator extends GeneratorForAnnotation<SealedUgh> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return "// Hey! Annotation found!";
  }
}
