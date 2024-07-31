import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';


//Se cambia a StatefulWidget para que se pueda hacer un scroll infinito
class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.subTitle, 
    this.loadNextPage
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener((){
      if(widget.loadNextPage == null){
        return;
      }

      if( (scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent){
        print("Load next");
        widget.loadNextPage!();
      } 

    });
  }

  //Siempre que se añade un Listener, se debe crear el dispose inmediatamente
  @override
  void dispose() {
    super.dispose(
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
         children: [
          
          //Si la pelicula no tiene title o subtitle, entonces no lo renderiza
          if( widget.title != null || widget.subTitle!= null )
          _Title(title: widget.title, subTitle: widget.subTitle,),


          Expanded(
            //ListView sin builder construye el widget en la memoria
            //Si es muy pesado para construirlo, es mejor usar ListView.builder
            child: ListView.builder(
              controller: scrollController, //Se debe relacionar al scrollController
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              }
            )
          )

         ],
      ),
    );
  }
}


class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const _Title({
    this.title, 
    this.subTitle
  });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      // Agrega un espacio  
      padding: const EdgeInsets.only( top: 10),
      margin: const EdgeInsets.symmetric( horizontal: 10),
      child: Row(
        children: [
          //Si el título es diferente de nulo, entonces se va a mostrar 
          if(  title != null)
            Text(title!, style: titleStyle,),
          
          const Spacer(),

          //Botón de fecha
          if(  subTitle != null)
            FilledButton.tonal(
              //Permite que el botón se ajuste al tamaño del texto
              style: const ButtonStyle( visualDensity: VisualDensity.compact ),
              onPressed: (){},
              child: Text(subTitle!)
            )

        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 8 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* IMAGEN
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress){
                  
                  if(loadingProgress != null){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: const CircularProgressIndicator(strokeWidth: 2,)),
                    );
                  }

                  return FadeIn(child: child);

                },
              ),
            ),
          ),

          const SizedBox(height: 5,),
          //* TÍTULO

          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyles.titleSmall,
            ),
          ),

          //* RATING
          Row(
            children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
              const SizedBox(width: 3,),
              Text(HumanFormats.dotNumber(movie.voteAverage), style: textStyles.bodyMedium?.copyWith( color: Colors.yellow.shade800),),
              const SizedBox(width: 10,),
              Text( HumanFormats.number(movie.popularity), style: textStyles.bodySmall,),
            
            ],
          ),
        ],
      ),
    );
  }
}