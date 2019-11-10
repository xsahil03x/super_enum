// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sealed_test.dart';

// **************************************************************************
// SealedUghGenerator
// **************************************************************************

abstract class SealedTest<T> {
  SealedTest(this._type);

  final _SealedTest _type;

//ignore: missing_return
  R when<R>(
      {@required R Function(FirstObj) onFirstObj,
      @required R Function(SecondObj) onSecondObj}) {
    switch (this._type) {
      case _SealedTest.FirstObj:
        return onFirstObj(this as FirstObj);
      case _SealedTest.SecondObj:
        return onSecondObj(this as SecondObj);
    }
  }
}

class FirstObj<T> extends SealedTest {
  FirstObj() : super(_SealedTest.FirstObj);
}

class SecondObj<T> extends SealedTest {
  SecondObj(this.value) : super(_SealedTest.SecondObj);

  final T value;
}
