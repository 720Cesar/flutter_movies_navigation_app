import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/** ARCHIVO QUE PERMITE TENER LOS DIFERENTES PROVIDERS */
// SE CREA UNA CLASE PARA MANTENER EL LISTADO DE LAS PELÍCULAS


// Proveedor de información que notifica cuando cambia el estado
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  // Se usa watch() en caso de que se llegue a cambiar la implementación
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});


final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getPopular;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getTopRated;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});



// Se define el tipo de callback que se espera
typedef MovieCallback = Future<List<Movie>> Function({ int page });

//Provider que controlará toda la información en el estado
class MoviesNotifier extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]);

  // Su objetivo es hacer una modificación al State
  Future<void> loadNextPage() async{
    if( isLoading ) return;

    isLoading = true; //Impide que haya más de una petición de nuevas peliculas
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies( page: currentPage );
    // Regresa el estado actual y el listado de las películas que encuentra
    state = [...state, ...movies];
    //Atrasa que la bandera pase a false
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;

  }

}


  