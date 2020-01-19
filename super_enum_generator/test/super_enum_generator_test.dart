import 'package:source_gen_test/source_gen_test.dart';
import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/generator.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  final generator_test_src = await initializeLibraryReaderForDirectory(
      'test/src', 'generator_test_src.dart');
  testAnnotatedElements<SuperEnum>(generator_test_src, SuperEnumGenerator());

  final use_class_test = await initializeLibraryReaderForDirectory(
      'test/src', 'use_class_test.dart');
  testAnnotatedElements<SuperEnum>(use_class_test, SuperEnumGenerator());
}
