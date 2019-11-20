import 'package:super_enum/super_enum.dart';

class Movies extends Equatable {
  final int page;
  final int totalResults;
  final int totalPages;
  final List<Movie> results;

  const Movies({this.page, this.totalResults, this.totalPages, this.results});

  factory Movies.fromJson(Map<String, dynamic> json) => Movies(
        page: json['page'],
        totalResults: json['total_results'],
        totalPages: json['total_pages'],
        results: (json['results'] as List)
                ?.map((v) => Movie.fromJson(v))
                ?.toList() ??
            [],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List get props => [
        page,
        totalResults,
        totalPages,
        results,
      ];
}

class Movie extends Equatable {
  final int voteCount;
  final int id;
  final bool video;
  final voteAverage;
  final String title;
  final double popularity;
  final String posterPath;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String backdropPath;
  final bool adult;
  final String overview;
  final String releaseDate;

  Movie(
      {this.voteCount,
      this.id,
      this.video,
      this.voteAverage,
      this.title,
      this.popularity,
      this.posterPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreIds,
      this.backdropPath,
      this.adult,
      this.overview,
      this.releaseDate});

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        voteCount: json['vote_count'],
        id: json['id'],
        video: json['video'],
        voteAverage: json['vote_average'],
        title: json['title'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        genreIds: json['genre_ids'].cast<int>(),
        backdropPath: json['backdrop_path'],
        adult: json['adult'],
        overview: json['overview'],
        releaseDate: json['release_date'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vote_count'] = this.voteCount;
    data['id'] = this.id;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['backdrop_path'] = this.backdropPath;
    data['adult'] = this.adult;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    return data;
  }

  @override
  List get props => [
        voteCount,
        id,
        video,
        voteAverage,
        title,
        popularity,
        posterPath,
        originalLanguage,
        originalTitle,
        genreIds,
        backdropPath,
        adult,
        overview,
        releaseDate
      ];
}
