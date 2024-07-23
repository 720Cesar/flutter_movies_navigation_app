import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {

  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
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
    //final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

    final slideShowMovies = ref.watch( moviesSlideshowProvider );

    return Column(

      children: [

        const CustomAppbar(),

        MoviesSlideshow(
          movies: slideShowMovies
        )
        
      ],

    );

  }
}