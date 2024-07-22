
// Provider que provee la información del repositorio 
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Este repositorio es inmutable, solo provee información (Solo de lectura)
// Permite declarar el proveedor de información, en este caso MovieDB
final movieRepositoryProvider = Provider((ref) {


  return MovieRepositoryImpl( MovieDbDatasource() );
});
