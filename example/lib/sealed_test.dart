import 'package:sealed_ugh/sealed_ugh.dart';

part "sealed_test.g.dart";

@sealed @generic
enum _SealedTest {
  
  @object
  FirstObj,

  @Data(fields: [DataField('f1', double), DataField('f2', int)])
  SecondObj,

  @Data(fields: [DataField('f1', int), DataField('f2', Generic)])
  @generic
  ThirdObj,

  @object
  FourthObj,
}

class MyClass {
  final String a;
  final int b;

  const MyClass(this.a, this.b);
}
