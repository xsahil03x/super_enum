import 'package:super_enum/super_enum.dart';
import 'package:source_gen_test/source_gen_test.dart';

@ShouldGenerate(r'''
@immutable
abstract class Result<T> extends Equatable {
  const Result(this._type);

  factory Result.success({@required T data, @required String message}) =
      Success<T>;

  factory Result.error() = Error<T>;

  final _Result _type;

//ignore: missing_return
  R when<R>(
      {@required R Function(Success) success,
      @required R Function(Error) error}) {
    switch (this._type) {
      case _Result.Success:
        return success(this as Success);
      case _Result.Error:
        return error(this as Error);
    }
  }

  R whenOrElse<R>(
      {R Function(Success) success,
      R Function(Error) error,
      @required R Function(Result) orElse}) {
    assert(() {
      if (orElse == null) throw 'Missing orElse case';
      return true;
    }());
    switch (this._type) {
      case _Result.Success:
        if (success == null) break;
        return success(this as Success);
      case _Result.Error:
        if (error == null) break;
        return error(this as Error);
    }
    return orElse(this);
  }

  FutureOr<void> whenPartial(
      {FutureOr<void> Function(Success) success,
      FutureOr<void> Function(Error) error}) {
    assert(() {
      if (success == null && error == null) throw 'provide at least one branch';
      return true;
    }());
    switch (this._type) {
      case _Result.Success:
        if (success == null) break;
        return success(this as Success);
      case _Result.Error:
        if (error == null) break;
        return error(this as Error);
    }
  }

  @override
  List get props => [];
}

@immutable
class Success<T> extends Result<T> {
  const Success({@required this.data, @required this.message})
      : super(_Result.Success);

  final T data;

  final String message;

  @override
  String toString() => 'Success(data:${this.data},message:${this.message})';
  @override
  List get props => [data, message];
}

@immutable
class Error<T> extends Result<T> {
  const Error._() : super(_Result.Error);

  factory Error() {
    _instance ??= Error._();
    return _instance;
  }

  static Error _instance;
}
''')
@superEnum
// ignore: unused_element
enum _Result {
  @generic
  @Data(fields: [
    DataField('data', Generic),
    DataField('message', String),
  ])
  Success,

  @object
  Error,
}
