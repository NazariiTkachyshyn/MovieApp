// lib/models/movie.dart
class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage; // Додано
  final String director; // Додано

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage, // Додано
    required this.director, // Додано
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'].toDouble(), // Додано
      director: json['director'] ?? 'Unknown', // Додано
    );
  }
  // Метод для оновлення режисера
  Movie copyWith({String? director}) {
    return Movie(
      id: id,
      title: title,
      director: director ?? this.director,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
    );
  }
}
