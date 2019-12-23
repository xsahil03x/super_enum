// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class MoviesResponse extends Equatable {
  const MoviesResponse(this._type);

  factory MoviesResponse.success({@required Movies movies}) = Success;

  factory MoviesResponse.unauthorized() = Unauthorized;

  factory MoviesResponse.noNetwork() = NoNetwork;

  factory MoviesResponse.unexpectedException({@required Exception exception}) =
      UnexpectedException;

  final _MoviesResponse _type;

//ignore: missing_return
  R when<R>(
      {@required R Function(Success) success,
      @required R Function(Unauthorized) unauthorized,
      @required R Function(NoNetwork) noNetwork,
      @required R Function(UnexpectedException) unexpectedException}) {
    switch (this._type) {
      case _MoviesResponse.Success:
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        return unauthorized(this as Unauthorized);
      case _MoviesResponse.NoNetwork:
        return noNetwork(this as NoNetwork);
      case _MoviesResponse.UnexpectedException:
        return unexpectedException(this as UnexpectedException);
    }
  }

  R whenOrElse<R>(
      {R Function(Success) success,
      R Function(Unauthorized) unauthorized,
      R Function(NoNetwork) noNetwork,
      R Function(UnexpectedException) unexpectedException,
      @required R Function(MoviesResponse) orElse}) {
    assert(() {
      if (orElse == null) throw 'Missing orElse case';
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        if (success == null) break;
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        if (unauthorized == null) break;
        return unauthorized(this as Unauthorized);
      case _MoviesResponse.NoNetwork:
        if (noNetwork == null) break;
        return noNetwork(this as NoNetwork);
      case _MoviesResponse.UnexpectedException:
        if (unexpectedException == null) break;
        return unexpectedException(this as UnexpectedException);
    }
    return orElse(this);
  }

  FutureOr<void> whenPartial(
      {FutureOr<void> Function(Success) success,
      FutureOr<void> Function(Unauthorized) unauthorized,
      FutureOr<void> Function(NoNetwork) noNetwork,
      FutureOr<void> Function(UnexpectedException) unexpectedException}) {
    assert(() {
      if (success == null &&
          unauthorized == null &&
          noNetwork == null &&
          unexpectedException == null) throw 'provide at least one branch';
      return true;
    }());
    switch (this._type) {
      case _MoviesResponse.Success:
        if (success == null) break;
        return success(this as Success);
      case _MoviesResponse.Unauthorized:
        if (unauthorized == null) break;
        return unauthorized(this as Unauthorized);
      case _MoviesResponse.NoNetwork:
        if (noNetwork == null) break;
        return noNetwork(this as NoNetwork);
      case _MoviesResponse.UnexpectedException:
        if (unexpectedException == null) break;
        return unexpectedException(this as UnexpectedException);
    }
  }

  @override
  List get props => [];
}

@immutable
class Success extends MoviesResponse {
  const Success({@required this.movies}) : super(_MoviesResponse.Success);

  final Movies movies;

  @override
  String toString() => 'Success(movies:${this.movies})';

  @override
  List get props => [movies];
}

@immutable
class Unauthorized extends MoviesResponse {
  const Unauthorized._() : super(_MoviesResponse.Unauthorized);

  factory Unauthorized() {
    _instance ??= Unauthorized._();
    return _instance;
  }

  static Unauthorized _instance;
}

@immutable
class NoNetwork extends MoviesResponse {
  const NoNetwork._() : super(_MoviesResponse.NoNetwork);

  factory NoNetwork() {
    _instance ??= NoNetwork._();
    return _instance;
  }

  static NoNetwork _instance;
}

@immutable
class UnexpectedException extends MoviesResponse {
  const UnexpectedException({@required this.exception})
      : super(_MoviesResponse.UnexpectedException);

  final Exception exception;

  @override
  String toString() => 'UnexpectedException(exception:${this.exception})';

  @override
  List get props => [exception];
}
