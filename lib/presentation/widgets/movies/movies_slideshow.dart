// WIDGET QUE PERMITE CREAR UN SLIDESHOW CON IMÁGENES

import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class MoviesSlideshow extends StatelessWidget {

  final List<Movie> movies; //Obtiene el listado de películas

  const MoviesSlideshow({
    super.key, 
    required this.movies
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return SizedBox( //Se usa un tamaño establecido para el slideshow
      height: 210,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8, //Permite ver una parte del slide anterior y el que sigue
        scale: 0.9, //Permite que el slide actual sea más grande que los otros
        autoplay: true, //Se mueve de forma automática
        pagination: SwiperPagination( //Permite agregar los puntos de cada slide
          margin: const EdgeInsets.only( top: 0 ), 
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          )
        ),
        itemCount: movies.length,
        itemBuilder: (context, index){
          final movie = movies[index]; //Se obtiene el index de cada pelicula
          return _Slide( 
            movie: movie,
            onMovieSelected: (context, movie){

            }, 
          );
        } 

      ),
    );
  }
}


class _Slide extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected; 

  const _Slide({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 7) //Permite colocar la sombra en una posición, en este caso hacia abajo
        )
      ]
    );

    return Padding(
      padding: const EdgeInsets.only( bottom: 30), //Deja un espacio para los puntos
      child: DecoratedBox(
        decoration: decoration,
        child: GestureDetector(
         onTap: () => context.push("/movie/${ movie.id }"),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), //Borde redondeado para imagen
            child: Image.network(
              movie.backdropPath,
              fit: BoxFit.cover, //Toma el espacio del contenedor 
              //Nos ayuda a saber si una imagen ya se construyó o no
              loadingBuilder: (context, child, loadingProgress){
                if( loadingProgress != null ){ //Si se está cargando la imagen, entonces...
                  return const DecoratedBox(
                    decoration: BoxDecoration( color: Colors.black12 )
                  );
                }
          
                //Si ya no está recargando la imagen, entonces se retorna el child
                return FadeIn(child: child);
          
              }
            ),
          ),
        )
      ),
    );
  }
}