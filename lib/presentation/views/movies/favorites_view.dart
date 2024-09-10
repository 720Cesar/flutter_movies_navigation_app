import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView>{

  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    
    super.initState();
    loadNextPage();

  }
  
  void loadNextPage() async{
    if( isLoading || isLastPage ) return; //Si hace alguno de esos dos, termina la función
    isLoading = true; //Se pasa a true antes de obtener las pelis

    //Obtiene el listado de pelis del Provider
    final movies = await ref.read(favoritesMoviesProvider.notifier).loadNextPage();
    isLoading = false; //Al obtener las pelis, se pasa a falso

    //Si se detecta que no hay más elementos en la lista, se indica que es la última página
    if( movies.isEmpty ){
      isLastPage = true;
    }

  }

  @override
  Widget build(BuildContext context) {

    final movieData = ref.watch( favoritesMoviesProvider );

    //* Otra forma de obtener los valores del mapa y convertirlos a una lista
    //final movieData = ref.watch( favoritesMoviesProvider ).values.toList();

    

    List<Movie> favoriteMovies = [];
    movieData.forEach((k,v) => favoriteMovies.add(v));

    if( favoriteMovies.isEmpty ){

      final colors = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Icon(Icons.favorite_outline_sharp, size: 60, color: colors.primary,),
            Text("Está muy vacío por aquí...", style: TextStyle( fontSize: 20, color: colors.primary),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Parece que no has agregado películas favoritas \n¿Por qué no empezar ahora?", style: TextStyle( fontSize: 12, color: Colors.white54 ), textAlign: TextAlign.center,),
            ),

            const SizedBox(height: 20,),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'), 
              child: const Text("Empieza a buscar")
            ),

          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(
        movies: favoriteMovies, 
        loadNextPage: (){
          ref.read(favoritesMoviesProvider.notifier).loadNextPage();
        },
      ),
    );
  }

}

