
// Provider que provee la información del repositorio 
import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



// Este repositorio es inmutable, solo provee información (Solo de lectura)
// Permite declarar el proveedor de información, en este caso MovieDB
final actorsRepositoryProvider = Provider((ref) {


  return ActorRepositoryImpl( ActorMoviedbDatasource() );
});