import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/generator.dart';
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
      'test/src', 'generator_test_src.dart');
  initializeBuildLogTracking();
  testAnnotatedElements<SuperEnum>(reader, SuperEnumGenerator());
}
