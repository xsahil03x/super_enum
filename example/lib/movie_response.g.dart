// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

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

  @override
  List get props => null;
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

@immutable
abstract class Attribute extends Equatable {
  const Attribute(this._type);

  factory Attribute.strength({@required int value}) = Strength;

  factory Attribute.intelligence({@required int value}) = Intelligence;

  factory Attribute.agility({@required int value}) = Agility;

  factory Attribute.dexterity({@required int value}) = Dexterity;

  factory Attribute.endurance({@required int value}) = Endurance;

  factory Attribute.speed({@required int value}) = Speed;

  final _Attribute _type;

//ignore: missing_return
  R when<R>(
      {@required R Function(Strength) strength,
      @required R Function(Intelligence) intelligence,
      @required R Function(Agility) agility,
      @required R Function(Dexterity) dexterity,
      @required R Function(Endurance) endurance,
      @required R Function(Speed) speed}) {
    switch (this._type) {
      case _Attribute.Strength:
        return strength(this as Strength);
      case _Attribute.Intelligence:
        return intelligence(this as Intelligence);
      case _Attribute.Agility:
        return agility(this as Agility);
      case _Attribute.Dexterity:
        return dexterity(this as Dexterity);
      case _Attribute.Endurance:
        return endurance(this as Endurance);
      case _Attribute.Speed:
        return speed(this as Speed);
    }
  }

  @override
  List get props => null;
}

@immutable
class Strength extends Attribute {
  const Strength({@required this.value}) : super(_Attribute.Strength);

  final int value;

  @override
  String toString() => 'Strength(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Intelligence extends Attribute {
  const Intelligence({@required this.value}) : super(_Attribute.Intelligence);

  final int value;

  @override
  String toString() => 'Intelligence(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Agility extends Attribute {
  const Agility({@required this.value}) : super(_Attribute.Agility);

  final int value;

  @override
  String toString() => 'Agility(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Dexterity extends Attribute {
  const Dexterity({@required this.value}) : super(_Attribute.Dexterity);

  final int value;

  @override
  String toString() => 'Dexterity(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Endurance extends Attribute {
  const Endurance({@required this.value}) : super(_Attribute.Endurance);

  final int value;

  @override
  String toString() => 'Endurance(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Speed extends Attribute {
  const Speed({@required this.value}) : super(_Attribute.Speed);

  final int value;

  @override
  String toString() => 'Speed(value:${this.value})';
  @override
  List get props => [value];
}
