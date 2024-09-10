
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref){
  
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);     
  
  return StorageMoviesNotifier(localStorageRepository );
});

/**
 * {
 *  1234: Movie,
 *  8192: Movie,
 *  0291: Movie,
 * }
 */

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier(
    this.localStorageRepository
  ): super({}); //Se inicializa el constructor como objeto vacío

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 20); //TODO: Limit 20
    page++; //Se pone en este punto para indicar que se cargan las siguientes 10 películas

    //Se hace de esa forma para evitar cargar el estado mientras esté el ciclo For
    final tempMoviesMap =   <int, Movie>{};
    for(final movie in movies){
      tempMoviesMap[movie.id] = movie; //Permite obtenerl el listado de pelis a partir de su ID en la BD
    }

    //Se emite un nuevo estado a partir del estado anterior (Spread)
    state = { ...state, ...tempMoviesMap };

    return movies;
  }

  //Método que permite agregar y eliminar pelis de forma dinámica
  Future<void> toggleFavorite( Movie movie ) async{
    await localStorageRepository.toggleFavorite(movie);

    //Verifica si la peli existe en favoritos o no
    final bool isMovieInFavorites = state[movie.id] != null;

    if ( isMovieInFavorites ){
      state.remove(movie.id); //Remueve del estado
      state = {...state }; //El nuevo estado es el estado anterior 
    }else{
      state = {...state, movie.id: movie}; //Agrega la nueva película
    }
  }

}