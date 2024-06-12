import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_app/models/movie.dart';

class ApiService {
  final String apiKey = '6c5e990d062e0a6c55eb9dc2b8a3a602';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchTopMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load top movies');
    }
  }

  Future<List<Movie>> fetchTop5Movies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies.take(5).toList();
    } else {
      throw Exception('Failed to load top 5 movies');
    }
  }

  Future<List<Movie>> fetchLatestMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies.take(18).toList();
    } else {
      throw Exception('Failed to load latest movies');
    }
  }

  // Інші методи для отримання даних
}
