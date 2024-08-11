
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

// EL ARCHIVO SOLO SIRVE DE PUENTE ENTRE EL DATASOURCE Y EL GÉSTOR DE ESTADOS

class ActorRepositoryImpl extends ActorsRepository {
  
  final ActorsDatasource datasource;

  ActorRepositoryImpl(this.datasource);
  
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }

}