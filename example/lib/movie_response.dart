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
