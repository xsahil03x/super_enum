import 'package:source_gen/source_gen.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:super_enum/super_enum.dart';
import 'package:super_enum_generator/src/generator.dart';

final test_src_files = [
  'generator_test_src.dart',
  'use_class_test_src.dart',
];

Future<void> main() async {
  List<LibraryReader> test_src = await Future.wait(test_src_files
      .map((it) => initializeLibraryReaderForDirectory('test/src', it)));
  initializeBuildLogTracking();

  for (final src in test_src) {
    testAnnotatedElements<SuperEnum>(src, SuperEnumGenerator());
  }
}
