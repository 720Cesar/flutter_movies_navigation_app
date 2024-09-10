import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {

  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry({
    super.key, 
    required this.movies, 
    this.loadNextPage
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {

  final scrollController = ScrollController();

  //TODO: initState

  @override
  void initState() {
    super.initState();

    scrollController.addListener((){
      if(widget.loadNextPage == null){
        return;
      }

      if( (scrollController.position.pixels) >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }

    });
  }

  //TODO: dispose
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3, //Número de columnas 
        mainAxisSpacing: 10, //Espacio entre elementos de filas
        crossAxisSpacing: 10, //Espacio entre elemtos de columnas
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {

          //Evalua el número de la columna para agregar un espacio dando un aspecto desordenado
          if( index == 1){
            return Column(
              children: [
                const SizedBox(height: 25,),
                MoviePosterLink( movie: widget.movies[index])
              ],
            );
          } 

          return MoviePosterLink( movie: widget.movies[index]);
        }
      ),
    );
  }
}