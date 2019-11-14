import 'package:analyzer/dart/element/element.dart';
import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/class_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';

Builder superEnumGeneratorFactoryBuilder() => SharedPartBuilder(
      [SuperEnumGenerator()],
      'super_enum',
    );

class SuperEnumGenerator extends GeneratorForAnnotation<SuperEnum> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return ClassGenerator(element).generate(DartFormatter());
  }
}
