import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mapppers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';

//EN ESTE ARCHIVO SE ENCUENTRA TODA LA LÓGICA PARA REALIZAR PETICIONES HTTP A LA API
// ES UNA ÚNICA PETICIÓN HTTP

class MovieDbDatasource extends MoviesDatasource{

  // Cliente HTTP de una API 
  // Dio
    final dio = Dio( BaseOptions(
      // La base URL se refiere a la parte del URL que no será jamás cambiada
      baseUrl: "https://api.themoviedb.org/3",
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      }
    ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    //Obtiene las peliculas por página para que las pelis no se repitan
    final response = await dio.get('/movie/now_playing',
    queryParameters: {
      "page" : page,
    });

    //Se recibe la respuesta del JSON en este caso de "now_playing"
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    //Retorna la respuesta del listado de películas como entidad
    final List<Movie> movies = movieDBResponse.results
    // Si hay poster, entonces sigue el código, si no hay poster entonces no crea la pelicula
    .where( (moviedb) => moviedb.posterPath != "no-poster" ) //Where permite poner una condición
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb)
    ).toList();

    return movies;

  }

}