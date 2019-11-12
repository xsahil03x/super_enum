import 'package:source_gen/source_gen.dart';

class TypeProcessor {
  static TypeChecker typeChecker(Type t) => TypeChecker.fromRuntime(t);
  static String typeOfParameter(obj) =>
      ConstantReader(obj).read('type').typeValue.toString();
}
