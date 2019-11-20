import 'package:super_enum/super_enum.dart';

import 'movies.dart';

part 'movie_response.g.dart';

@superEnum
enum _MoviesResponse {
  @Data(fields: [DataField('movies', Movies)])
  Success,
  @object
  Unauthorized,
  @object
  NoNetwork,
  @Data(fields: [DataField('exception', Exception)])
  UnexpectedException
}

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