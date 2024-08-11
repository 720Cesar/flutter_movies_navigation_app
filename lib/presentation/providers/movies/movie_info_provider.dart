import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String,Movie>>((ref) {
  final getMovie = ref.watch(movieRepositoryProvider).getMovieById;

  return MovieMapNotifier(
    getMovie: getMovie,
  );

});

//Definición del callback
typedef GetMovieCallback = Future<Movie>Function( String movieId );

class MovieMapNotifier extends StateNotifier<Map<String,Movie>>{

  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie,
  }): super({});

  Future<void> loadMovie( String movieId ) async {
    //Si el state tiene el movieId, entonces no regresa nada
    if ( state[movieId] != null ) return;
    print("Realizando petición HTTP");

    final movie = await getMovie( movieId );

    //Clona el estado anterior con "..." y añade el movieId que apunta a movie si es que existe
    state = {...state, movieId: movie};

  }

}