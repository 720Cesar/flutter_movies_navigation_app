



import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




//Función que permite obtener una Lista de Películas únicamente para el SearchDelegate
typedef SearchMoviesCallback = Future<List<Movie>> Function( String query );

//La clase siempre te obliga a sobreescribir los 4 métodos y regresa de forma opcional una "Movie"
class SearchMovieDelegate extends SearchDelegate<Movie?>{


  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  //broadcast permite que el Stream sea escuchado más de una vez en diferentes lugares
  //Si se sabe que solo es un widget el que escucha el Stream de deja "StremController" sin broadcast
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer; //Timer permite determinar un periodo de tiempo

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });


  //Permite limpiar todos los Streams cuando se usa el SearchDelegate
  void clearStreams(){
    debouncedMovies.close();
  }

  //Método que permite saber en que momento ha cambiado el query
  void _onQueryChanged( String query ){
    isLoadingStream.add(true); //Añade el valor true al provider 
     
    //!print("Query cambió");
    
    //Sirve para cancelar el Timer si está activo. 
    if( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();

    //Espera 500 mil cuando el usuario deja de escribir
    _debounceTimer = Timer(const Duration( milliseconds: 500 ), () async {
    //!print("Buscando xdx");
    
    final movies = await searchMovies( query );
    debouncedMovies.add(movies);
    initialMovies = movies; //Asigna las películas a initialMovies para tener siempre películas
    isLoadingStream.add(false);

    });

  }


  //* MÉTODO PARA EL STREAM DE LA BÚSQUEDA
  Widget buildResultsAndSuggestions() {
     return StreamBuilder(
      
      initialData: initialMovies, //Permite mostrar las películas que se buscaron primero
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        
        //! print("Realizando petición");

        //Verifica si hay data en el snapshot, en caso contrario, se agrega una lista vacía "[]"
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
              movie: movies[index],
              onMovieSelected: (context, movie){ //Necesita "context" ya que es una función genérica
                clearStreams();
                close(context, movie); //Función close es global de SearchDelegate
              }, 
            );
          }
        );
      }
    ); 
  }



  //Permite cambiar el texto de la barra del búscador
  @override
  String get searchFieldLabel => "Buscar película";
  
  //Se debe cumplir el retorno que es una Lista de Widgets
  @override
  List<Widget>? buildActions(BuildContext context) {
    bool? isLoading;
    return [

        StreamBuilder(
          stream: isLoadingStream.stream, 
          builder: (context, snapshot){
          isLoading = snapshot.data;

            // return isLoading == true ? SpinPerfect(duration: const Duration(seconds: 20), spins: 10, infinite: true, child: IconButton(onPressed: () => query = "",icon: const Icon(Icons.refresh_rounded)),)
            // : FadeIn(animate: query.isNotEmpty, child: IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear),),);
           
           if ( isLoading ?? false){
            return SpinPerfect(
              duration: const Duration(seconds: 10),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = "", //Pone en blanco la barra buscadora 
                icon: const Icon(Icons.refresh_rounded)
              ),
            );
           }

           return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                onPressed: () => query = "", //Pone en blanco la barra buscadora 
                icon: const Icon(Icons.clear)
              ),
            );
           
            


          },
        ),

        

  
    ];
  }

  //ES OPCIONAL, Puede regresar cualquier widget, incluso un "null"
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      //Permite cerrar la búsqueda, se pone "null" suponiendo que la persona no hizo nada
      onPressed: () {
        clearStreams();
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back)
    );
  }

  //ES OBLIGATORIO, se tiene que regresar un widget 
  @override
  Widget buildResults(BuildContext context) {
     return buildResultsAndSuggestions();
  }

  //ES OBLIGATORIO, regresa un widget. Se dispara para construirse cuando la persona escribe algo
  @override
  Widget buildSuggestions(BuildContext context) {
    

    _onQueryChanged(query);

    return buildResultsAndSuggestions();
  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected; 

  const _MovieItem({
    required this.movie, 
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {
    
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    
    return GestureDetector(
      onTap: () => context.push("/home/0/movie/${ movie.id }"),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
      
      
            //* Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),
      
            const SizedBox(width: 10,),
      
      
            //* Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title, 
                    style: const TextStyle(fontWeight: FontWeight.bold ) 
                  ), 
                  
                  ( movie.overview.length > 100)
                    ? Text("${movie.overview.substring(0,100)}...") //Permite que el texto no se muestre completo
                    : Text( movie.overview ),
      
      
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                      SizedBox( width: 5,),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1), //1 es el numero de decimales
                        style: textStyles.bodySmall!.copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  ),
      
                ],
              ),
            ),
      
      
      
          ],
        ),
      ),
    );
  }
}