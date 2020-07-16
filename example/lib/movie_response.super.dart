// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: return_of_invalid_type, constant_identifier_names, prefer_const_constructors_in_immutables, unnecessary_this, sort_unnamed_constructors_first, join_return_with_assignment, missing_return, lines_longer_than_80_chars

part of 'movie_response.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class MoviesResponse extends Equatable {
  const MoviesResponse(this._type);

  factory MoviesResponse.success({@required Movies movies}) = Success.create;

  factory MoviesResponse.unauthorized() = Unauthorized.create;

  factory MoviesResponse.noNetwork() = NoNetwork.create;

  factory MoviesResponse.unexpectedException({@required Exception exception}) =
      UnexpectedException.create;

  final _MoviesResponse _type;

  R when<R>(
      {@required R Function(Success) success,
      @required R Function() unauthorized,
      @required R Function() noNetwork,
      @required R Function(UnexpectedException) unexpectedException}) {
    assert(() {
      if (success == null ||
          unauthorized == null ||
          noNetwork == null ||
          unexpectedException == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        return unauthorized();
      case _MoviesResponse.NoNetwork:
        return noNetwork();
      case _MoviesResponse.UnexpectedException:
        return unexpectedException(this as UnexpectedException);
    }
  }

  Future<R> asyncWhen<R>(
      {@required
          FutureOr<R> Function(Success) success,
      @required
          FutureOr<R> Function() unauthorized,
      @required
          FutureOr<R> Function() noNetwork,
      @required
          FutureOr<R> Function(UnexpectedException) unexpectedException}) {
    assert(() {
      if (success == null ||
          unauthorized == null ||
          noNetwork == null ||
          unexpectedException == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        return unauthorized();
      case _MoviesResponse.NoNetwork:
        return noNetwork();
      case _MoviesResponse.UnexpectedException:
        return unexpectedException(this as UnexpectedException);
    }
  }

  R whenOrElse<R>(
      {R Function(Success) success,
      R Function() unauthorized,
      R Function() noNetwork,
      R Function(UnexpectedException) unexpectedException,
      @required R Function(MoviesResponse) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        if (success == null) break;
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        if (unauthorized == null) break;
        return unauthorized();
      case _MoviesResponse.NoNetwork:
        if (noNetwork == null) break;
        return noNetwork();
      case _MoviesResponse.UnexpectedException:
        if (unexpectedException == null) break;
        return unexpectedException(this as UnexpectedException);
    }
    return orElse(this);
  }

  Future<R> asyncWhenOrElse<R>(
      {FutureOr<R> Function(Success) success,
      FutureOr<R> Function() unauthorized,
      FutureOr<R> Function() noNetwork,
      FutureOr<R> Function(UnexpectedException) unexpectedException,
      @required FutureOr<R> Function(MoviesResponse) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        if (success == null) break;
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        if (unauthorized == null) break;
        return unauthorized();
      case _MoviesResponse.NoNetwork:
        if (noNetwork == null) break;
        return noNetwork();
      case _MoviesResponse.UnexpectedException:
        if (unexpectedException == null) break;
        return unexpectedException(this as UnexpectedException);
    }
    return orElse(this);
  }

  Future<void> whenPartial(
      {FutureOr<void> Function(Success) success,
      FutureOr<void> Function() unauthorized,
      FutureOr<void> Function() noNetwork,
      FutureOr<void> Function(UnexpectedException) unexpectedException}) {
    assert(() {
      if (success == null &&
          unauthorized == null &&
          noNetwork == null &&
          unexpectedException == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        if (success == null) break;
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        if (unauthorized == null) break;
        return unauthorized();
      case _MoviesResponse.NoNetwork:
        if (noNetwork == null) break;
        return noNetwork();
      case _MoviesResponse.UnexpectedException:
        if (unexpectedException == null) break;
        return unexpectedException(this as UnexpectedException);
    }
  }

  @override
  List<Object> get props => const [];
}

@immutable
abstract class Success extends MoviesResponse {
  const Success({@required this.movies}) : super(_MoviesResponse.Success);

  factory Success.create({@required Movies movies}) = _SuccessImpl;

  final Movies movies;

  Success copyWith({Movies movies});
}

@immutable
class _SuccessImpl extends Success {
  const _SuccessImpl({@required this.movies}) : super(movies: movies);

  @override
  final Movies movies;

  @override
  _SuccessImpl copyWith({Object movies = superEnum}) => _SuccessImpl(
        movies: movies == superEnum ? this.movies : movies as Movies,
      );
  @override
  String toString() => 'Success(movies: ${this.movies})';
  @override
  List<Object> get props => [movies];
}

@immutable
abstract class Unauthorized extends MoviesResponse {
  const Unauthorized() : super(_MoviesResponse.Unauthorized);

  factory Unauthorized.create() = _UnauthorizedImpl;
}

@immutable
class _UnauthorizedImpl extends Unauthorized {
  const _UnauthorizedImpl() : super();

  @override
  String toString() => 'Unauthorized()';
}

@immutable
abstract class NoNetwork extends MoviesResponse {
  const NoNetwork() : super(_MoviesResponse.NoNetwork);

  factory NoNetwork.create() = _NoNetworkImpl;
}

@immutable
class _NoNetworkImpl extends NoNetwork {
  const _NoNetworkImpl() : super();

  @override
  String toString() => 'NoNetwork()';
}

@immutable
abstract class UnexpectedException extends MoviesResponse {
  const UnexpectedException({@required this.exception})
      : super(_MoviesResponse.UnexpectedException);

  factory UnexpectedException.create({@required Exception exception}) =
      _UnexpectedExceptionImpl;

  final Exception exception;

  UnexpectedException copyWith({Exception exception});
}

@immutable
class _UnexpectedExceptionImpl extends UnexpectedException {
  const _UnexpectedExceptionImpl({@required this.exception})
      : super(exception: exception);

  @override
  final Exception exception;

  @override
  _UnexpectedExceptionImpl copyWith({Object exception = superEnum}) =>
      _UnexpectedExceptionImpl(
        exception:
            exception == superEnum ? this.exception : exception as Exception,
      );
  @override
  String toString() => 'UnexpectedException(exception: ${this.exception})';
  @override
  List<Object> get props => [exception];
}
