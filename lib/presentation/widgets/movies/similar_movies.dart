import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final similarMoviesProvider = FutureProvider.family((ref, int movieId){
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getSimilar(movieId);
});


class SimilarMovies extends ConsumerWidget {

  final int movieId;

  const SimilarMovies({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final similarMoviesFuture = ref.watch(similarMoviesProvider(movieId));

    return similarMoviesFuture.when(
      data: ( movies ) => _Similar(movies: movies), 
      error: (_ , __) => const Center(child: Text("Error al cargar películas similares :("),), 
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2,),),
    );
  }
}

class _Similar extends StatelessWidget {

  final List<Movie> movies;

  const _Similar({ required this.movies });

  @override
  Widget build(BuildContext context) {
    
    if(movies.isEmpty) return const SizedBox();
    
    return Container(

      margin: const EdgeInsetsDirectional.only(bottom: 50),
      child: MovieHorizontalListview(title: "Peliculas similares", movies: movies),
    );
  }
}