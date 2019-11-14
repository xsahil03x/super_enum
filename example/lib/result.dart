import 'package:super_enum/super_enum.dart';

part "result.g.dart";

@superEnum
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
