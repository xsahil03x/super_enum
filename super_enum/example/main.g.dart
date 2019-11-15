// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class MovieResponse {
  const MovieResponse(this._type);

  factory MovieResponse.success({@required Movies movies}) = Success;

  factory MovieResponse.unauthorized() = Unauthorized;

  factory MovieResponse.noNetwork() = NoNetwork;

  factory MovieResponse.unexpectedException({@required Exception exception}) =
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
}

@immutable
class Success extends MovieResponse {
  const Success({@required this.movies}) : super(_MoviesResponse.Success);

  final Movies movies;
}

@immutable
class Unauthorized extends MovieResponse {
  const Unauthorized() : super(_MoviesResponse.Unauthorized);
}

@immutable
class NoNetwork extends MovieResponse {
  const NoNetwork() : super(_MoviesResponse.NoNetwork);
}

@immutable
class UnexpectedException extends MovieResponse {
  const UnexpectedException({@required this.exception})
      : super(_MoviesResponse.UnexpectedException);

  final Exception exception;
}
