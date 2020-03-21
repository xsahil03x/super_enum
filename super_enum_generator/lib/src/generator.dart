import 'package:analyzer/dart/element/element.dart';
import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/class_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';

Builder superEnumGeneratorFactoryBuilder() => PartBuilder(
      [SuperEnumGenerator()],
      '.super.dart',
      header: "// GENERATED CODE - DO NOT MODIFY BY HAND\n"
          "// ignore_for_file: "
          "return_of_invalid_type, "
          "constant_identifier_names, "
          "prefer_const_constructors_in_immutables, "
          "unnecessary_this, "
          "sort_unnamed_constructors_first, "
          "join_return_with_assignment, "
          "missing_return, "
          "lines_longer_than_80_chars",
    );

class SuperEnumGenerator extends GeneratorForAnnotation<SuperEnum> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return ClassGenerator(element).generate(DartFormatter());
  }
}
