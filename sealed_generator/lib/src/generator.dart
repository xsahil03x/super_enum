import 'package:analyzer/dart/element/element.dart';
import 'package:sealed/sealed.dart';
import 'package:sealed_generator/src/class_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';


Builder sealedGeneratorFactoryBuilder() => SharedPartBuilder(
      [SealedGenerator()],
      'sealed',
    );

class SealedGenerator extends GeneratorForAnnotation<Sealed> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return ClassGenerator(element).generate(DartFormatter());
  }
}
