import 'package:source_gen_test/source_gen_test.dart';
import 'package:super_enum/super_enum.dart';

@ShouldGenerate(r'''
@immutable
abstract class ResultUnion extends Equatable {
  const ResultUnion(this._type);

  factory ResultUnion.success(MySuccess mySuccess) = MySuccessWrapper;

  factory ResultUnion.error(MyError myError) = MyErrorWrapper;

  final _ResultUnion _type;

//ignore: missing_return
  FutureOr<R> when<R>(
      {@required FutureOr<R> Function(MySuccess) success,
      @required FutureOr<R> Function(MyError) error}) {
    assert(() {
      if (success == null || error == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _ResultUnion.Success:
        return success((this as MySuccessWrapper).mySuccess);
      case _ResultUnion.Error:
        return error((this as MyErrorWrapper).myError);
    }
  }

  FutureOr<R> whenOrElse<R>(
      {FutureOr<R> Function(MySuccess) success,
      FutureOr<R> Function(MyError) error,
      @required FutureOr<R> Function(ResultUnion) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _ResultUnion.Success:
        if (success == null) break;
        return success((this as MySuccessWrapper).mySuccess);
      case _ResultUnion.Error:
        if (error == null) break;
        return error((this as MyErrorWrapper).myError);
    }
    return orElse(this);
  }

  FutureOr<void> whenPartial(
      {FutureOr<void> Function(MySuccess) success,
      FutureOr<void> Function(MyError) error}) {
    assert(() {
      if (success == null && error == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _ResultUnion.Success:
        if (success == null) break;
        return success((this as MySuccessWrapper).mySuccess);
      case _ResultUnion.Error:
        if (error == null) break;
        return error((this as MyErrorWrapper).myError);
    }
  }

  @override
  List get props => const [];
}

@immutable
class MySuccessWrapper extends ResultUnion {
  const MySuccessWrapper(this.mySuccess) : super(_ResultUnion.Success);

  final MySuccess mySuccess;

  @override
  String toString() => 'MySuccessWrapper($mySuccess)';
  @override
  List get props => [mySuccess];
}

@immutable
class MyErrorWrapper extends ResultUnion {
  const MyErrorWrapper(this.myError) : super(_ResultUnion.Error);

  final MyError myError;

  @override
  String toString() => 'MyErrorWrapper($myError)';
  @override
  List get props => [myError];
}
''')
@superEnum
// ignore: unused_element
enum _ResultUnion {
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