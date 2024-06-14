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

      // Додаємо інформацію про режисера до кожного фільму
      for (int i = 0; i < movies.length; i++) {
        String director = await fetchDirector(movies[i].id);
        print('!!!!!!!!!!!!!!');
        print(director);
        movies[i] = movies[i].copyWith(director: director);
      }

      return movies;
    } else {
      throw Exception('Failed to load top movies');
    }
  }

  Future<List<Movie>> fetchTop5Movies() async {
    int amount = 5;
    final response =
        await http.get(Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      // Додаємо інформацію про режисера до кожного фільму
      for (int i = 0; i < amount; i++) {
        String director = await fetchDirector(movies[i].id);
        movies[i] = movies[i].copyWith(director: director);
      }
      return movies.take(amount).toList();
    } else {
      throw Exception('Failed to load top 5 movies');
    }
  }

  Future<List<Movie>> fetchLatestMovies() async {
    int amount = 18;
    final response =
        await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      // Додаємо інформацію про режисера до кожного фільму
      for (int i = 0; i < amount; i++) {
        String director = await fetchDirector(movies[i].id);
        movies[i] = movies[i].copyWith(director: director);
      }
      return movies.take(amount).toList();
    } else {
      throw Exception('Failed to load latest movies');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetailsWithCredits(int movieId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<String> fetchDirector(int movieId) async {
    final movieDetails = await fetchMovieDetailsWithCredits(movieId);
    final crew = movieDetails['credits']['crew'] as List;
    final director = crew.firstWhere((member) => member['job'] == 'Director',
        orElse: () => null);
    return director != null ? director['name'] : 'Unknown';
  }

  // Інші методи для отримання даних
}
