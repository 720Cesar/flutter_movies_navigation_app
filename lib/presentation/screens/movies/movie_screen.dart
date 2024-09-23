import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_read_more_text/animated_read_more_text.dart';
import '../../providers/providers.dart';




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

class _MovieDetails extends ConsumerWidget {

  final Movie movie;

  const _MovieDetails({ required this.movie });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        //Póster, titulo y descripción
        _PosterAndOverview(movie: movie, size: size, textStyles: textStyles),
        
        //GÉNERO DE LA PELÍCULA
        _MovieGenre(movie: movie),
        
        //EL ID QUE SE OBTIENE ES UN STRING, POR LO QUE SE DEBE MANDAR EL VALOR COMO TAL
        _ActorsByMovie(movieId: movie.id.toString()),

        // CALIFICACIÓN DE LA PELÍCULA
        _MovieCalification(movie: movie)

        //* PELICULAS SIMILARES
         

      ],
    );
  }
}


// Otro tipo de Provider de Riverpod
// Sirve para cuando se tiene un tipo de tarea asíncrona, una vez que se resuelve la tarea,
// entonces se obtiene el valor
// family() permite mandar otro argumento, porque se necesita el ID de la película en la BD
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId){
  
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  //Devuelve un valor booleano a isMovieFavorite para saber si está el ID de la peli
  return localStorageRepository.isMovieFavorite(movieId); //Si está en favoritos
});

//* PÓSTER Y DESCRIPCIÓN
class _PosterAndOverview extends StatelessWidget {

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  const _PosterAndOverview({
    required this.movie,
    required this.size,
    required this.textStyles, 
  });

  @override
  Widget build(BuildContext context) {  
    
    final colors = Theme.of(context).colorScheme;

    return Padding(
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
                

                AnimatedReadMoreText(
                movie.overview,
                  maxLines: 8,
                  readMoreText: "+",
                  readLessText: "-",
                  buttonTextStyle: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
                
              ],
            ),
          ),

        ],
      ),
    );
  }
}

//* GÉNERO DE LA PELÍCULA
class _MovieGenre extends StatelessWidget {

  final Movie movie;

  const _MovieGenre({ required this.movie });

  @override
  Widget build(BuildContext context) {    

    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap( //Widget que muestra un texto con un fondo
        children: [
          ...movie.genreIds.map((gender) => Container(
            margin: const EdgeInsets.only(right: 10),
            child: Chip(
              label: Text( gender, style: TextStyle(color: colors.inversePrimary), ),
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
              backgroundColor: colors.primary,
            ),
          ))
        ],
      ),
    );
  }
}

//* ACTORES DE LA PELÍCULA
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
      height: 280,
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
                  style: const TextStyle( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis ),

                ),
                //Si no hay personaje, no se muestra nada
                Text(actor.character ?? "", 
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle( fontSize: 11, overflow: TextOverflow.ellipsis),
                ),


              ],
            ),
          );

        }
      ),
    );
  }
}

//* CALIFICACIÓN DE LA PELÍCULA
class _MovieCalification extends StatelessWidget {

  final Movie movie;

  const _MovieCalification({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Calificación general", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.yellow.shade900
              ),),
            Row(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              SizedBox( 
                width: size.width * 0.2,
                child: 
                Lottie.asset("assets/animations/star_rating_animation.json", animate: true, repeat: true),
              ),

              Text(HumanFormats.number(movie.voteAverage,1), style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.1,
                color: Colors.yellow.shade900
              ),),

              Padding(
                padding: const EdgeInsetsDirectional.only(start: 50),
                child: Text("*Basado en ${movie.voteCount} votos", style: const TextStyle(
                  fontSize: 12,
                ),),
              ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

//* Widget personalizado que muestra una barra superior con una imagen de fondo
class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppBar({ 
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //Se obtienen las dimensiones del dispositivo físico
    final size = MediaQuery.of(context).size;

    //Instancia al provider para el cambio del icono
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.24,
      foregroundColor: Colors.white,
      actions: [
        
        //* FORMA DE USAR UN FUTURE PROVIDER
        IconButton(onPressed: () async {

          //Llama al provider provider para poder insertar el ID de la nueva película en favoritos
          //ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
          //Se necesita primero insertar a la BD antes de invalidar el estado
          await ref.read(favoritesMoviesProvider.notifier).toggleFavorite(movie);

          //Invalida el estado del provider y lo regresa a su estado original
          ref.invalidate(isFavoriteProvider(movie.id));

        },
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite 
            ? const Icon(Icons.favorite_rounded, color: Colors.red,) //Si está en favoritos, se muestra el icono rojo
            : const Icon(Icons.favorite_border), 
            error: (_, __) => throw  UnimplementedError(), 
            loading: () => const CircularProgressIndicator(strokeWidth: 2,) //Mientras realiza la consulta
          ),
        ),


      ],
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
                movie.backdropPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress){
                  if( loadingProgress != null ) return SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            //* GRADIENTE

            const _CustomGradient(
              begin: Alignment.topCenter, 
              stops: [0.7,1.0], 
              colors: [Colors.transparent, Colors.black54]
            ),

            const _CustomGradient(
              begin: Alignment.topRight, 
              end: Alignment.bottomLeft,
              stops: [0.0,0.2], 
              colors: [Colors.black54, Colors.transparent]
            ),

            const _CustomGradient(
              begin: Alignment.topLeft, 
              stops: [0.0,0.4], 
              colors: [Colors.black87, Colors.transparent]
            ),

            const _CustomGradient(
              begin: Alignment.bottomRight,
              stops: [0.05,0.8], 
              colors: [Colors.black, Colors.transparent]
            ),


          ],
        ),
      ),



    );
  }
}

//* Widget para el gradiente de las imágenes
class _CustomGradient extends StatelessWidget {
  
  final AlignmentGeometry begin;
  final AlignmentGeometry? end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin, 
    this.end, 
    required this.stops, 
    required this.colors
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  stops: stops,
                  colors: colors
                ),
              ),
            ),
          );
  }
}