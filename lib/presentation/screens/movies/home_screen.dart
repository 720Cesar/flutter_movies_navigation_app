import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {

  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

// El statefulWidget pasa a ser ConsumerStatefulWidget
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  //Se cambia a una instancia de la clase _HomeViewState
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();

    //Se pone el provider en tipo lectura con loadNextPage
    //Se manda a llamar la petición, pero no la muestra 
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    
  }

  @override
  Widget build(BuildContext context) {

    //Watch porque debe estar pendiente del provider para el listado de las películas
    //ref.watch permite obtener los valores del provider
    
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final slideShowMovies = ref.watch( moviesSlideshowProvider );


    //SingleChildScrollView() es un widget que permite hacer Scroll al widget hijo (Column())
    //Los Slivers tienen que trabajar con el CustomScrollView
    
    return CustomScrollView(
      //El Sliver es un tipo de widget que trabaja unicamente con los ScrollView
      slivers: [

        const SliverAppBar(
          floating: true, //Permite que el appBar aparezca cuando se hace Scroll hacía abajo
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(), //No puede ser constante por la posición
            titlePadding: EdgeInsets.zero, //Permite que no haya un padding en el título
            centerTitle: false,
          ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index){
            return Column(
              children: [
            
                //const CustomAppbar(),
            
                MoviesSlideshow(movies: slideShowMovies),
            
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "En cines",
                  subTitle: "Junio",
                  loadNextPage: (){
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  }
                ),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "Proximamente",
                  subTitle: "En este mes",
                  loadNextPage: (){
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  }
                ),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "Populares",
                  //subTitle: "",
                  loadNextPage: (){
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  }
                ),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "Mejor calificadas",
                  subTitle: "Desde siempre",
                  loadNextPage: (){
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  }
                ),

                const SizedBox(height: 20,),
                
              ],
            
            );
          },
          childCount: 1, //Establece el número de hijos
        ),
      ),

      ]
      
      
    );

  }
}