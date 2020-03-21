import 'package:super_enum/super_enum.dart';

part 'example.super.dart';

@superEnum
enum _Attribute {
  @Data(fields: [DataField<int>('value')])
  Strength,
  @Data(fields: [DataField<int>('value')])
  Intelligence,
  @Data(fields: [DataField<int>('value')])
  Agility,
  @Data(fields: [DataField<int>('value')])
  Dexterity,
  @Data(fields: [DataField<int>('value')])
  Endurance,
  @Data(fields: [DataField<int>('value')])
  Speed
}
