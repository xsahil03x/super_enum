// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

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
    assert(() {
      if (strength == null ||
          intelligence == null ||
          agility == null ||
          dexterity == null ||
          endurance == null ||
          speed == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
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

//ignore: missing_return
  Future<R> asyncWhen<R>(
      {@required FutureOr<R> Function(Strength) strength,
      @required FutureOr<R> Function(Intelligence) intelligence,
      @required FutureOr<R> Function(Agility) agility,
      @required FutureOr<R> Function(Dexterity) dexterity,
      @required FutureOr<R> Function(Endurance) endurance,
      @required FutureOr<R> Function(Speed) speed}) {
    assert(() {
      if (strength == null ||
          intelligence == null ||
          agility == null ||
          dexterity == null ||
          endurance == null ||
          speed == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
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

  R whenOrElse<R>(
      {R Function(Strength) strength,
      R Function(Intelligence) intelligence,
      R Function(Agility) agility,
      R Function(Dexterity) dexterity,
      R Function(Endurance) endurance,
      R Function(Speed) speed,
      @required R Function(Attribute) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _Attribute.Strength:
        if (strength == null) break;
        return strength(this as Strength);
      case _Attribute.Intelligence:
        if (intelligence == null) break;
        return intelligence(this as Intelligence);
      case _Attribute.Agility:
        if (agility == null) break;
        return agility(this as Agility);
      case _Attribute.Dexterity:
        if (dexterity == null) break;
        return dexterity(this as Dexterity);
      case _Attribute.Endurance:
        if (endurance == null) break;
        return endurance(this as Endurance);
      case _Attribute.Speed:
        if (speed == null) break;
        return speed(this as Speed);
    }
    return orElse(this);
  }

  Future<R> asyncWhenOrElse<R>(
      {FutureOr<R> Function(Strength) strength,
      FutureOr<R> Function(Intelligence) intelligence,
      FutureOr<R> Function(Agility) agility,
      FutureOr<R> Function(Dexterity) dexterity,
      FutureOr<R> Function(Endurance) endurance,
      FutureOr<R> Function(Speed) speed,
      @required FutureOr<R> Function(Attribute) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _Attribute.Strength:
        if (strength == null) break;
        return strength(this as Strength);
      case _Attribute.Intelligence:
        if (intelligence == null) break;
        return intelligence(this as Intelligence);
      case _Attribute.Agility:
        if (agility == null) break;
        return agility(this as Agility);
      case _Attribute.Dexterity:
        if (dexterity == null) break;
        return dexterity(this as Dexterity);
      case _Attribute.Endurance:
        if (endurance == null) break;
        return endurance(this as Endurance);
      case _Attribute.Speed:
        if (speed == null) break;
        return speed(this as Speed);
    }
    return orElse(this);
  }

//ignore: missing_return
  Future<void> whenPartial(
      {FutureOr<void> Function(Strength) strength,
      FutureOr<void> Function(Intelligence) intelligence,
      FutureOr<void> Function(Agility) agility,
      FutureOr<void> Function(Dexterity) dexterity,
      FutureOr<void> Function(Endurance) endurance,
      FutureOr<void> Function(Speed) speed}) {
    assert(() {
      if (strength == null &&
          intelligence == null &&
          agility == null &&
          dexterity == null &&
          endurance == null &&
          speed == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _Attribute.Strength:
        if (strength == null) break;
        return strength(this as Strength);
      case _Attribute.Intelligence:
        if (intelligence == null) break;
        return intelligence(this as Intelligence);
      case _Attribute.Agility:
        if (agility == null) break;
        return agility(this as Agility);
      case _Attribute.Dexterity:
        if (dexterity == null) break;
        return dexterity(this as Dexterity);
      case _Attribute.Endurance:
        if (endurance == null) break;
        return endurance(this as Endurance);
      case _Attribute.Speed:
        if (speed == null) break;
        return speed(this as Speed);
    }
  }

  @override
  List get props => const [];
}

@immutable
class Strength extends Attribute {
  const Strength({@required this.value}) : super(_Attribute.Strength);

  final int value;

  Strength copyWith({int value}) => Strength(value: value ?? this.value);
  @override
  String toString() => 'Strength(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Intelligence extends Attribute {
  const Intelligence({@required this.value}) : super(_Attribute.Intelligence);

  final int value;

  Intelligence copyWith({int value}) =>
      Intelligence(value: value ?? this.value);
  @override
  String toString() => 'Intelligence(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Agility extends Attribute {
  const Agility({@required this.value}) : super(_Attribute.Agility);

  final int value;

  Agility copyWith({int value}) => Agility(value: value ?? this.value);
  @override
  String toString() => 'Agility(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Dexterity extends Attribute {
  const Dexterity({@required this.value}) : super(_Attribute.Dexterity);

  final int value;

  Dexterity copyWith({int value}) => Dexterity(value: value ?? this.value);
  @override
  String toString() => 'Dexterity(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Endurance extends Attribute {
  const Endurance({@required this.value}) : super(_Attribute.Endurance);

  final int value;

  Endurance copyWith({int value}) => Endurance(value: value ?? this.value);
  @override
  String toString() => 'Endurance(value:${this.value})';
  @override
  List get props => [value];
}

@immutable
class Speed extends Attribute {
  const Speed({@required this.value}) : super(_Attribute.Speed);

  final int value;

  Speed copyWith({int value}) => Speed(value: value ?? this.value);
  @override
  String toString() => 'Speed(value:${this.value})';
  @override
  List get props => [value];
}
