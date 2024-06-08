// lib/bloc/movie_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_service.dart';

class MovieState {
  final List<Movie> movies;
  final bool isLoading;
  final String error;

  MovieState(
      {required this.movies, required this.isLoading, required this.error});
}

class MovieEvent {}

class FetchMovies extends MovieEvent {}

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final ApiService apiService;

  MovieBloc({required this.apiService})
      : super(MovieState(movies: [], isLoading: false, error: '')) {
    on<FetchMovies>((event, emit) async {
      emit(MovieState(movies: [], isLoading: true, error: ''));
      try {
        final movies = await apiService.fetchTopMovies();
        emit(MovieState(movies: movies, isLoading: false, error: ''));
      } catch (e) {
        emit(MovieState(movies: [], isLoading: false, error: e.toString()));
      }
    });
  }
}
