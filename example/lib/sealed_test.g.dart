// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sealed_test.dart';

// **************************************************************************
// SealedUghGenerator
// **************************************************************************

@immutable
abstract class SealedTest<T> {
  const SealedTest(this._type);

  final _SealedTest _type;

//ignore: missing_return
  R when<R>(
      {@required R Function(FirstObj) onFirstObj,
      @required R Function(SecondObj) onSecondObj,
      @required R Function(ThirdObj) onThirdObj,
      @required R Function(FourthObj) onFourthObj}) {
    switch (this._type) {
      case _SealedTest.FirstObj:
        return onFirstObj(this as FirstObj);
      case _SealedTest.SecondObj:
        return onSecondObj(this as SecondObj);
      case _SealedTest.ThirdObj:
        return onThirdObj(this as ThirdObj);
      case _SealedTest.FourthObj:
        return onFourthObj(this as FourthObj);
    }
  }
}

@immutable
class FirstObj extends SealedTest {
  const FirstObj() : super(_SealedTest.FirstObj);
}

@immutable
class SecondObj extends SealedTest {
  const SecondObj({@required this.f1, @required this.f2})
      : super(_SealedTest.SecondObj);

  final double f1;

  final int f2;
}

@immutable
class ThirdObj<T> extends SealedTest {
  const ThirdObj({@required this.f1, @required this.f2})
      : super(_SealedTest.ThirdObj);

  final int f1;

  final T f2;
}

@immutable
class FourthObj extends SealedTest {
  const FourthObj() : super(_SealedTest.FourthObj);
}
