
// CREACIÓN DE UN WIDGET CON UN APPBAR CUSTOMIZADO

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    
    // Se asigna un área segura por si hay algún obstaculo para renderizar el widget
    return SafeArea(
      bottom: false, //Elimina el espacio de abajo del SafeArea
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 10 ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon( Icons.movie_outlined, color: colors.primary, ),
              const SizedBox( width: 5,),
              Text("CinemaPedia", style: titleStyle,),
              
              //Spacer es un widget que toma todo un espacio disponible
              //En este caso ayuda a mover el texto del título y el ícono de búsqueda
              const Spacer(),
              
              IconButton(
                onPressed: (){
                  
                  //Se hace la lectura al provider para la función de búsqueda de películas
                  final searchedMovies = ref.read(searchMoviesProvider );
                  final searchQuery = ref.read( searchQueryProvider );

                  //* NAVEGACIÓN CON EL ÍCONO DE BÚSQUEDA
                  showSearch<Movie?>( //Movie es opcional ya que el usuario se salga de la búsqueda
                    query: searchQuery, //Obtiene el string del provider
                    //Se requiere el contexto general de la app
                    context: context,
                    //Se encarga de trabajar la búsqueda
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      searchMovies: ref.read( searchMoviesProvider.notifier ).searchMoviesByQuery //Referencia a la función 
                    ),
                  ).then((movie) {
                    
                    //Si no hay registro de la película, no regresa nada
                    if( movie == null ) return;

                    //Si hay registro, lleva a la pantalla de la película
                    context.push("/movie/${ movie.id }");

                  });                  

                }, 
                icon: const Icon( Icons.search ),
              ),
            ],
          ),
        ),
      )
    );
  }
}