import 'package:source_gen_test/source_gen_test.dart';
import 'package:super_enum/super_enum.dart';

@ShouldGenerate(r'''
/// Result Union UseClass
@immutable
abstract class ResultUnion extends Equatable {
  const ResultUnion(this._type);

  /// Success case Of the Result Union
  factory ResultUnion.success(MySuccess mySuccess) = MySuccessWrapper;

  /// Error case Of the Result Union
  factory ResultUnion.error(MyError myError) = MyErrorWrapper;

  /// SpecialError case Of the Result Union
  factory ResultUnion.specialError(MyError myError) = MyErrorWrapper;

  /// YetAnotherError case Of the Result Union
  factory ResultUnion.yetAnotherError(MyError myError) = YaeWrapper;

  final _ResultUnion _type;

  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the _ResultUnion [_type]s defined.
  R when<R extends Object>(
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

  /// The [whenOrElse] method is equivalent to [when], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R whenOrElse<R extends Object>(
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

  /// The [whenPartial] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  void whenPartial(
      {void Function(MySuccess) success,
      void Function(MyError) error,
      void Function(MyError) specialError,
      void Function(MyError) yetAnotherError}) {
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

/// Result Union UseClass
@superEnum
enum _ResultUnion {
  /// Success case Of the Result Union
  @UseClass(MySuccess)
  Success,

  /// Error case Of the Result Union
// duplicate class without custom name, doesn't result in double wrapper
  @UseClass(MyError)
  Error,

  /// SpecialError case Of the Result Union
// duplicate class without custom name, doesn't result in double wrapper
  @UseClass(MyError)
  SpecialError,

  /// YetAnotherError case Of the Result Union
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
