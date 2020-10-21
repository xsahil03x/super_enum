import 'package:super_enum/super_enum.dart';

part 'example.super.dart';

/// Possible Types of Attribute
@superEnum
enum _Attribute {
  /// Strength Attribute type
  @Data(fields: [DataField<int>('value')])
  Strength,

  /// Intelligence Attribute type
  @Data(fields: [DataField<int>('value')])
  Intelligence,

  /// Agility Attribute type
  @Data(fields: [DataField<int>('value')])
  Agility,

  /// Dexterity Attribute type
  @Data(fields: [DataField<int>('value')])
  Dexterity,

  /// Endurance Attribute type
  @Data(fields: [DataField<int>('value')])
  Endurance,

  /// Speed Attribute type
  @Data(fields: [DataField<int>('value')])
  Speed
}
