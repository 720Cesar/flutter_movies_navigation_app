
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource{

  //Métodos que deben ser implementados sí o sí (No importa si es cualquier gestor de DB)
  Future<void> toggleFavorite( Movie movie );
  Future<bool> isMovieFavorite( int movieId );
  Future<List<Movie>> loadMovies({ int limit = 10, offset = 0});

}