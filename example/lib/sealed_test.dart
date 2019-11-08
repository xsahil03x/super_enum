import 'package:sealed_ugh/sealed_ugh.dart';

part "sealed_test.g.dart";

@sealed
enum _SealedTest {
  @object
  FirstObj,
  @Data()
  SecondObj,
}
