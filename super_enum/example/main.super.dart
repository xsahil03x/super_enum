// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: return_of_invalid_type, constant_identifier_names, prefer_const_constructors_in_immutables, unnecessary_this, sort_unnamed_constructors_first, join_return_with_assignment, missing_return, lines_longer_than_80_chars

part of 'main.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

/// MovieResponse Possible States
@immutable
abstract class MoviesResponse extends Equatable {
  const MoviesResponse(this._type);

  /// Success State of the MovieResponse
  factory MoviesResponse.success({required Movies movies}) = Success.create;

  /// Unauthorized State of the MovieResponse
  factory MoviesResponse.unauthorized() = Unauthorized.create;

  /// NoNetwork State of the MovieResponse
  factory MoviesResponse.noNetwork() = NoNetwork.create;

  /// UnexpectedException State of the MovieResponse
  factory MoviesResponse.unexpectedException({required Object exception}) =
      UnexpectedException.create;

  final _MoviesResponse _type;

  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the _MoviesResponse [_type]s defined.
  R when<R>(
      {required R Function(Success) onSuccess,
      required R Function() onUnauthorized,
      required R Function() onNoNetwork,
      required R Function(UnexpectedException) onUnexpectedException}) {
    switch (this._type) {
      case _MoviesResponse.Success:
        return onSuccess(this as Success);
      case _MoviesResponse.Unauthorized:
        return onUnauthorized();
      case _MoviesResponse.NoNetwork:
        return onNoNetwork();
      case _MoviesResponse.UnexpectedException:
        return onUnexpectedException(this as UnexpectedException);
    }
  }

  /// The [whenOrElse] method is equivalent to [when], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R whenOrElse<R>(
      {R Function(Success)? onSuccess,
      R Function()? onUnauthorized,
      R Function()? onNoNetwork,
      R Function(UnexpectedException)? onUnexpectedException,
      required R Function(MoviesResponse) orElse}) {
    switch (this._type) {
      case _MoviesResponse.Success:
        if (onSuccess == null) break;
        return onSuccess(this as Success);
      case _MoviesResponse.Unauthorized:
        if (onUnauthorized == null) break;
        return onUnauthorized();
      case _MoviesResponse.NoNetwork:
        if (onNoNetwork == null) break;
        return onNoNetwork();
      case _MoviesResponse.UnexpectedException:
        if (onUnexpectedException == null) break;
        return onUnexpectedException(this as UnexpectedException);
    }
    return orElse(this);
  }

  /// The [whenPartial] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  void whenPartial(
      {void Function(Success)? onSuccess,
      void Function()? onUnauthorized,
      void Function()? onNoNetwork,
      void Function(UnexpectedException)? onUnexpectedException}) {
    assert(() {
      if (onSuccess == null &&
          onUnauthorized == null &&
          onNoNetwork == null &&
          onUnexpectedException == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        if (onSuccess == null) break;
        return onSuccess(this as Success);
      case _MoviesResponse.Unauthorized:
        if (onUnauthorized == null) break;
        return onUnauthorized();
      case _MoviesResponse.NoNetwork:
        if (onNoNetwork == null) break;
        return onNoNetwork();
      case _MoviesResponse.UnexpectedException:
        if (onUnexpectedException == null) break;
        return onUnexpectedException(this as UnexpectedException);
    }
  }

  @override
  List<Object> get props => const [];
}

/// Success State of the MovieResponse
@immutable
abstract class Success extends MoviesResponse {
  const Success({required this.movies}) : super(_MoviesResponse.Success);

  /// Success State of the MovieResponse
  factory Success.create({required Movies movies}) = _SuccessImpl;

  final Movies movies;

  /// Creates a copy of this Success but with the given fields
  /// replaced with the new values.
  Success copyWith({Movies movies});
}

@immutable
class _SuccessImpl extends Success {
  const _SuccessImpl({required this.movies}) : super(movies: movies);

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

/// Unauthorized State of the MovieResponse
@immutable
abstract class Unauthorized extends MoviesResponse {
  const Unauthorized() : super(_MoviesResponse.Unauthorized);

  /// Unauthorized State of the MovieResponse
  factory Unauthorized.create() = _UnauthorizedImpl;
}

@immutable
class _UnauthorizedImpl extends Unauthorized {
  const _UnauthorizedImpl() : super();

  @override
  String toString() => 'Unauthorized()';
}

/// NoNetwork State of the MovieResponse
@immutable
abstract class NoNetwork extends MoviesResponse {
  const NoNetwork() : super(_MoviesResponse.NoNetwork);

  /// NoNetwork State of the MovieResponse
  factory NoNetwork.create() = _NoNetworkImpl;
}

@immutable
class _NoNetworkImpl extends NoNetwork {
  const _NoNetworkImpl() : super();

  @override
  String toString() => 'NoNetwork()';
}

/// UnexpectedException State of the MovieResponse
@immutable
abstract class UnexpectedException extends MoviesResponse {
  const UnexpectedException({required this.exception})
      : super(_MoviesResponse.UnexpectedException);

  /// UnexpectedException State of the MovieResponse
  factory UnexpectedException.create({required Object exception}) =
      _UnexpectedExceptionImpl;

  final Object exception;

  /// Creates a copy of this UnexpectedException but with the given fields
  /// replaced with the new values.
  UnexpectedException copyWith({Exception exception});
}

@immutable
class _UnexpectedExceptionImpl extends UnexpectedException {
  const _UnexpectedExceptionImpl({required this.exception})
      : super(exception: exception);

  @override
  final Object exception;

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
