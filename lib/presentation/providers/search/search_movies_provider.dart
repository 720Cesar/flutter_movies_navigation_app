
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider que permite obtener un String (El query de búsqueda)
final searchQueryProvider = StateProvider<String>((ref) => ""); 

final searchMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {  

  //Se obtiene el provider de la implementación
  final movieRepository = ref.read( movieRepositoryProvider );


  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies,
    ref: ref,
  );

});

typedef SearchMoviesCallback = Future<List<Movie>>Function( String query);


//* CLASE PARA OBTENER LAS ÚLTIMAS PELÍCULAS BUSCADAS
class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  

  final SearchMoviesCallback searchMovies; 
  final Ref ref;

  //Estado inicial, un arreglo vacío
  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }): super([]);

  //Función asincrona que permite obtener el estado de la última lista de películas de la búsqueda
  Future<List<Movie>> searchMoviesByQuery( String query ) async {
      
    //Las películas que estarán en el listado y se mantiene el estado de la búsqueda del usuario
    final List<Movie> movies = await searchMovies(query);  
    ref.read(searchQueryProvider.notifier).update((state) => query);    
    
    //Se manda al estado para mantener las últimas películas de búsqueda
    state = movies;
    return state;
  }

}