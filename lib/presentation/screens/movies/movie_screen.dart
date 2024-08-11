import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Pasa de StatefulWidget a ConsumerStatefulWidget
class MovieScreen extends ConsumerStatefulWidget {

  static const name = "movie-screen";

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  //Se coloca el nombre de la clase 
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

 @override
  void initState() {
    super.initState();

    //NOTA: Cuando se está dentro de métodos, es recomendable usar el read()
    //Esto realiza una petición HTTP
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);

  } 

  //* CACHÉ
  @override
  Widget build(BuildContext context) {

    //El mapa movies busca el elemento 
    final Movie? movies = ref.watch( movieInfoProvider )[widget.movieId];
    
    //Si no hay películas en caché, entonces muestra una animación de carga
    if ( movies == null ){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator( strokeWidth: 2,),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(), //Evita la animación de rebote
        slivers: [
          _CustomSliverAppBar(movie:  movies),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movies),
            childCount: 1
          ))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {

  final Movie movie;

  const _MovieDetails({ required this.movie });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox( width: 10,),

              //* DESCRIPCIÓN DE LA PELÍCULA
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Descripción", style: textStyles.titleLarge,),
                    Text(movie.overview),
                  ],
                ),
              ),

            ],
          ),
        ),

        //* GÉNERO DE LA PELÍCULA
        Padding(
          padding: EdgeInsets.all(8),
          child: Wrap( //Widget que muestra un texto con un fondo
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text( gender, style: TextStyle(color: Colors.white), ),
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                  backgroundColor: colors.primary,

                ),
              ))
            ],
          ),
        ),
        
        //TODO: MOSTRAR ACTORES
        //EL ID QUE SE OBTIENE ES UN STRING, POR LO QUE SE DEBE MANDAR EL VALOR COMO TAL
        _ActorsByMovie(movieId: movie.id.toString()),

        const SizedBox( height: 50,),

      ],
    );
  }
}


class _ActorsByMovie extends ConsumerWidget {
  
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    //Se está pendiente si hay actores con el provider
    final actorsByMovie = ref.watch( actorsByMovieProvider );

    if( actorsByMovie[movieId] == null){
      return const CircularProgressIndicator(strokeWidth: 2,);
    }

    final actors = actorsByMovie[movieId]!;

    //* DISEÑO DE CAJAS PARA LOS ACTORES
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              children: [

                // ACTOR PHOTO
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ACTOR NAME
                const SizedBox(height: 5,),
                

                Text(actor.name, 
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  //"TextOverflow" permite mostrar "..." si el texto sobresale
                  style: TextStyle( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis ),

                ),
                //Si no hay personaje, no se muestra nada
                Text(actor.character ?? "", 
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle( fontSize: 11, overflow: TextOverflow.ellipsis),
                ),


              ],
            ),
          );

        }
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomSliverAppBar({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {

    //Se obtienen las dimensiones del dispositivo físico
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      //title: Text(movie.title),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.start,
          
        ),

        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress){
                  if( loadingProgress != null ) return SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            //* GRADIENTE
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5,1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ]
                  ),
                ),
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0,0.4],
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ]
                  ),
                ),
              ),
            ),

          ],
        ),
      ),



    );
  }
}