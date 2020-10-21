import 'package:source_gen_test/source_gen_test.dart';
import 'package:super_enum/super_enum.dart';

@ShouldGenerate(r'''
/// Generic Result Union
@immutable
abstract class Result<T> extends Equatable {
  const Result(this._type);

  /// Success case Of the Result
  factory Result.success({@required T data, @required String message}) =
      Success<T>.create;

  /// Error case Of the Result
  factory Result.error() = Error<T>.create;

  final _Result _type;

  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the _Result [_type]s defined.
  R when<R extends Object>(
      {@required R Function(Success<T>) success,
      @required R Function() error}) {
    assert(() {
      if (success == null || error == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _Result.Success:
        return success(this as Success);
      case _Result.Error:
        return error();
    }
  }

  /// The [whenOrElse] method is equivalent to [when], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R whenOrElse<R extends Object>(
      {R Function(Success<T>) success,
      R Function() error,
      @required R Function(Result<T>) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _Result.Success:
        if (success == null) break;
        return success(this as Success);
      case _Result.Error:
        if (error == null) break;
        return error();
    }
    return orElse(this);
  }

  /// The [whenPartial] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  void whenPartial({void Function(Success<T>) success, void Function() error}) {
    assert(() {
      if (success == null && error == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _Result.Success:
        if (success == null) break;
        return success(this as Success);
      case _Result.Error:
        if (error == null) break;
        return error();
    }
  }

  @override
  List<Object> get props => const [];
}

/// Success case Of the Result
@immutable
abstract class Success<T> extends Result<T> {
  const Success({@required this.data, @required this.message})
      : super(_Result.Success);

  /// Success case Of the Result
  factory Success.create({@required T data, @required String message}) =
      _SuccessImpl<T>;

  final T data;

  final String message;

  /// Creates a copy of this Success but with the given fields
  /// replaced with the new values.
  Success<T> copyWith({T data, String message});
}

@immutable
class _SuccessImpl<T> extends Success<T> {
  const _SuccessImpl({@required this.data, @required this.message})
      : super(data: data, message: message);

  @override
  final T data;

  @override
  final String message;

  @override
  _SuccessImpl<T> copyWith(
          {Object data = superEnum, Object message = superEnum}) =>
      _SuccessImpl(
        data: data == superEnum ? this.data : data as T,
        message: message == superEnum ? this.message : message as String,
      );
  @override
  String toString() => 'Success(data: ${this.data}, message: ${this.message})';
  @override
  List<Object> get props => [data, message];
}

/// Error case Of the Result
@immutable
abstract class Error<T> extends Result<T> {
  const Error() : super(_Result.Error);

  /// Error case Of the Result
  factory Error.create() = _ErrorImpl<T>;
}

@immutable
class _ErrorImpl<T> extends Error<T> {
  const _ErrorImpl() : super();

  @override
  String toString() => 'Error()';
}
''')

/// Generic Result Union
@superEnum
enum _Result {
  /// Success case Of the Result
  @generic
  @Data(fields: [
    DataField<Generic>('data'),
    DataField<String>('message'),
  ])
  Success,

  /// Error case Of the Result
  @object
  Error,
}
