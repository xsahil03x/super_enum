import 'package:super_enum/super_enum.dart';

part 'example.g.dart';

@superEnum
enum _Attribute {
  @Data(fields: [DataField('value', int)])
  Strength,
  @Data(fields: [DataField('value', int)])
  Intelligence,
  @Data(fields: [DataField('value', int)])
  Agility,
  @Data(fields: [DataField('value', int)])
  Dexterity,
  @Data(fields: [DataField('value', int)])
  Endurance,
  @Data(fields: [DataField('value', int)])
  Speed
}
