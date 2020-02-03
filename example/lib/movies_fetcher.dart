import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:io';

import 'movie_response.dart';
import 'movies.dart';

class MoviesFetcher {
  final _baseUrl = "http://api.themoviedb.org/3/movie";

  final String apiKey;
  http.Client client;

  MoviesFetcher({
    http.Client client,
    @required this.apiKey,
  }) : client = client ?? http.Client();

  Stream<MoviesResponse> fetchMovies() async* {
    try {
      final response = await client.get('$_baseUrl/popular?api_key=$apiKey');
      if (response.statusCode == 200) {
        final movies = Movies.fromJson(json.decode(response.body));
        yield MoviesResponse.success(movies: movies);
      } else {
        yield MoviesResponse.unauthorized();
      }
    } on SocketException {
      yield MoviesResponse.noNetwork();
    } catch (e) {
      yield MoviesResponse.unexpectedException(exception: e);
    }
  }
}
