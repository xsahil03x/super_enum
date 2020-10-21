import 'package:super_enum/super_enum.dart';

import 'movies.dart';

part 'movie_response.super.dart';

/// MovieResponse Possible States
@superEnum
enum _MoviesResponse {
  /// Success State of the MovieResponse
  @Data(fields: [DataField<Movies>('movies')])
  Success,

  /// Unauthorized State of the MovieResponse
  @object
  Unauthorized,

  /// NoNetwork State of the MovieResponse
  @object
  NoNetwork,

  /// UnexpectedException State of the MovieResponse
  @Data(fields: [DataField<Exception>('exception')])
  UnexpectedException
}
