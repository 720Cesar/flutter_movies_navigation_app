

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_respository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String,List<Actor>>>((ref) {
  final actorsRepository = ref.watch(actorsRepositoryProvider);

  return ActorsByMovieNotifier(
    getActors: actorsRepository.getActorsByMovie,
  );

});

//Definición del callback 
typedef GetActorsCallback = Future<List<Actor>>Function( String movieId );

class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>>{

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors,
  }): super({});

  Future<void> loadActors( String movieId ) async {
    //Si el state tiene el movieId, entonces no regresa nada
    if ( state[movieId] != null ) return;

    final List<Actor> actors = await getActors( movieId );

    //Clona el estado anterior con "..." y añade el movieId que apunta a movie si es que existe
    state = {...state, movieId: actors};

  }

}