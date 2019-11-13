import 'package:sealed/sealed.dart';
import 'package:sealed_generator/src/generator.dart';
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
      'test/src', 'generator_test_src.dart');
  initializeBuildLogTracking();
  testAnnotatedElements<Sealed>(reader, SealedGenerator());
}
