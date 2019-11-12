import 'package:sealed_ugh/sealed_ugh.dart';

part "result.g.dart";

@sealed
enum _Result {
  @generic
  @Data(fields: [
    DataField('data', Generic),
    DataField('message', String),
  ])
  Success,

  @Data(fields: [DataField('exception', Exception)])
  Error,
}
