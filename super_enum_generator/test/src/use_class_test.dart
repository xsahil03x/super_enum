import 'package:source_gen_test/source_gen_test.dart';
import 'package:super_enum/super_enum.dart';

@ShouldGenerate(r'''
@immutable
abstract class Result2 extends Equatable {
  const Result2(this._type);

  factory Result2.success(MySuccess mySuccess) = MySuccessWrapper;

  factory Result2.error(MyError myError) = MyErrorWrapper;

  final _Result2 _type;

//ignore: missing_return
  FutureOr<R> when<R>(
      {@required FutureOr<R> Function(MySuccess) success,
      @required FutureOr<R> Function(MyError) error}) {
    assert(() {
      if (success == null || error == null)
        throw 'check for all possible cases';
      return true;
    }());
    switch (this._type) {
      case _Result2.Success:
        return success((this as MySuccessWrapper).mySuccess);
      case _Result2.Error:
        return error((this as MyErrorWrapper).myError);
    }
  }

  FutureOr<R> whenOrElse<R>(
      {FutureOr<R> Function(MySuccess) success,
      FutureOr<R> Function(MyError) error,
      @required FutureOr<R> Function(Result2) orElse}) {
    assert(() {
      if (orElse == null) throw 'Missing orElse case';
      return true;
    }());
    switch (this._type) {
      case _Result2.Success:
        if (success == null) break;
        return success((this as MySuccessWrapper).mySuccess);
      case _Result2.Error:
        if (error == null) break;
        return error((this as MyErrorWrapper).myError);
    }
    return orElse(this);
  }

  FutureOr<void> whenPartial(
      {FutureOr<void> Function(MySuccess) success,
      FutureOr<void> Function(MyError) error}) {
    assert(() {
      if (success == null && error == null) throw 'provide at least one branch';
      return true;
    }());
    switch (this._type) {
      case _Result2.Success:
        if (success == null) break;
        return success((this as MySuccessWrapper).mySuccess);
      case _Result2.Error:
        if (error == null) break;
        return error((this as MyErrorWrapper).myError);
    }
  }

  @override
  List get props => const [];
}

@immutable
class MySuccessWrapper extends Result2 {
  const MySuccessWrapper(this.mySuccess) : super(_Result2.Success);

  final MySuccess mySuccess;

  @override
  String toString() => 'MySuccessWrapper($mySuccess)';
  @override
  List get props => [mySuccess];
}

@immutable
class MyErrorWrapper extends Result2 {
  const MyErrorWrapper(this.myError) : super(_Result2.Error);

  final MyError myError;

  @override
  String toString() => 'MyErrorWrapper($myError)';
  @override
  List get props => [myError];
}
''')
@superEnum
// ignore: unused_element
enum _Result2 {
  @UseClass(MySuccess)
  Success,

  @UseClass(MyError)
  Error,
}

class MySuccess {
  MySuccess(this.fieldA);

  final String fieldA;
}

class MyError {
  MyError(this.fieldA, this.fieldB);

  final String fieldA;
  final int fieldB;
}
