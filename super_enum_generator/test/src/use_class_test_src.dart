import 'package:source_gen_test/source_gen_test.dart';
import 'package:super_enum/super_enum.dart';

@ShouldGenerate(r'''
@immutable
abstract class ResultUnion extends Equatable {
  const ResultUnion(this._type);

  factory ResultUnion.success(MySuccess mySuccess) = MySuccessWrapper;

  factory ResultUnion.error(MyError myError) = MyErrorWrapper;

  factory ResultUnion.specialError(MyError myError) = MyErrorWrapper;

  factory ResultUnion.yetAnotherError(MyError myError) = YaeWrapper;

  final _ResultUnion _type;

  R when<R>(
      {@required R Function(MySuccess) success,
      @required R Function(MyError) error,
      @required R Function(MyError) specialError,
      @required R Function(MyError) yetAnotherError}) {
    assert(() {
      if (success == null ||
          error == null ||
          specialError == null ||
          yetAnotherError == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _ResultUnion.Success:
        return success((this as MySuccessWrapper).mySuccess);
      case _ResultUnion.Error:
        return error((this as MyErrorWrapper).myError);
      case _ResultUnion.SpecialError:
        return specialError((this as MyErrorWrapper).myError);
      case _ResultUnion.YetAnotherError:
        return yetAnotherError((this as YaeWrapper).myError);
    }
  }

  Future<R> asyncWhen<R>(
      {@required FutureOr<R> Function(MySuccess) success,
      @required FutureOr<R> Function(MyError) error,
      @required FutureOr<R> Function(MyError) specialError,
      @required FutureOr<R> Function(MyError) yetAnotherError}) {
    assert(() {
      if (success == null ||
          error == null ||
          specialError == null ||
          yetAnotherError == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _ResultUnion.Success:
        return success((this as MySuccessWrapper).mySuccess);
      case _ResultUnion.Error:
        return error((this as MyErrorWrapper).myError);
      case _ResultUnion.SpecialError:
        return specialError((this as MyErrorWrapper).myError);
      case _ResultUnion.YetAnotherError:
        return yetAnotherError((this as YaeWrapper).myError);
    }
  }

  R whenOrElse<R>(
      {R Function(MySuccess) success,
      R Function(MyError) error,
      R Function(MyError) specialError,
      R Function(MyError) yetAnotherError,
      @required R Function(ResultUnion) orElse}) {
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
      case _ResultUnion.SpecialError:
        if (specialError == null) break;
        return specialError((this as MyErrorWrapper).myError);
      case _ResultUnion.YetAnotherError:
        if (yetAnotherError == null) break;
        return yetAnotherError((this as YaeWrapper).myError);
    }
    return orElse(this);
  }

  Future<R> asyncWhenOrElse<R>(
      {FutureOr<R> Function(MySuccess) success,
      FutureOr<R> Function(MyError) error,
      FutureOr<R> Function(MyError) specialError,
      FutureOr<R> Function(MyError) yetAnotherError,
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
      case _ResultUnion.SpecialError:
        if (specialError == null) break;
        return specialError((this as MyErrorWrapper).myError);
      case _ResultUnion.YetAnotherError:
        if (yetAnotherError == null) break;
        return yetAnotherError((this as YaeWrapper).myError);
    }
    return orElse(this);
  }

  Future<void> whenPartial(
      {FutureOr<void> Function(MySuccess) success,
      FutureOr<void> Function(MyError) error,
      FutureOr<void> Function(MyError) specialError,
      FutureOr<void> Function(MyError) yetAnotherError}) {
    assert(() {
      if (success == null &&
          error == null &&
          specialError == null &&
          yetAnotherError == null) {
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
      case _ResultUnion.SpecialError:
        if (specialError == null) break;
        return specialError((this as MyErrorWrapper).myError);
      case _ResultUnion.YetAnotherError:
        if (yetAnotherError == null) break;
        return yetAnotherError((this as YaeWrapper).myError);
    }
  }

  @override
  List<Object> get props => const [];
}

@immutable
class MySuccessWrapper extends ResultUnion {
  const MySuccessWrapper(this.mySuccess) : super(_ResultUnion.Success);

  final MySuccess mySuccess;

  @override
  String toString() => 'MySuccessWrapper($mySuccess)';
  @override
  List<Object> get props => [mySuccess];
}

@immutable
class MyErrorWrapper extends ResultUnion {
  const MyErrorWrapper(this.myError) : super(_ResultUnion.Error);

  final MyError myError;

  @override
  String toString() => 'MyErrorWrapper($myError)';
  @override
  List<Object> get props => [myError];
}

@immutable
class YaeWrapper extends ResultUnion {
  const YaeWrapper(this.myError) : super(_ResultUnion.YetAnotherError);

  final MyError myError;

  @override
  String toString() => 'YaeWrapper($myError)';
  @override
  List<Object> get props => [myError];
}
''')
@superEnum
// ignore: unused_element
enum _ResultUnion {
  @UseClass(MySuccess)
  Success,

  // duplicate class without custom name, doesn't result in double wrapper
  @UseClass(MyError)
  Error,

  // duplicate class without custom name, doesn't result in double wrapper
  @UseClass(MyError)
  SpecialError,

  // Custom name for the wrapper
  @UseClass(MyError, name: "YaeWrapper")
  YetAnotherError,
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
