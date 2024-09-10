
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * ARCHIVO CREADO CON EL FIN DE ARREGLAR EL PROBLEMA DEL CAMBIO DEL ÍCONO
 */

final isFavoriteProvider = StateNotifierProvider.family<FavoriteNotifier, bool, int>((ref, movieId){
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return FavoriteNotifier(localStorageRepository, movieId);
});

class FavoriteNotifier extends StateNotifier<bool> {
  final LocalStorageRepository localStorageRepository;
  final int movieId;

  FavoriteNotifier(this.localStorageRepository, this.movieId) : super(false){
    _loadFavoriteStatus(); //Obtiene el status que indica si la peli es fav o no 
  }

  //Permite obtener el valor booleano para saber si la película está en favoritos o no, lo devuelve en el estado
  Future<void> _loadFavoriteStatus() async {
    final isFavorite = await localStorageRepository.isMovieFavorite(movieId);
    state = isFavorite;
  }

  //Permite reconocer cual es la película a la que se ha agreado o quitado de favoritos
  Future<void> toggleFavorite(Movie movie) async{
    await localStorageRepository.toggleFavorite(movie);
    state = !state;
  }

}

