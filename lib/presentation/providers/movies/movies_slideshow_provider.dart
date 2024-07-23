/** 
 * PROVIDER DE SOLO LECTURA QUE OBTIENE EL LISTADO DE MOVIES Y 
 * EVALUA SI HAY ALGUNA, SI HAY PELÍCULAS ENTONCES REGRESA 6 DE ELLAS
 */

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref){


  final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

  //Si no hay películas, entonces regresa un arreglo vacío
  if ( nowPlayingMovies.isEmpty ) return [];

  //Si hay películas, entonces regresa 6 de ellas
  return nowPlayingMovies.sublist(0,6);

});
