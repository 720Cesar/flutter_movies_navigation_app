import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mapppers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

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

  //Método que recibe un Map y de tipo JSON
  List<Movie> _jsonToMovies( Map<String,dynamic> json){
    
    final movieDBResponse = MovieDbResponse.fromJson(json);

    //Retorna la respuesta del listado de películas como entidad
    final List<Movie> movies = movieDBResponse.results
    // Si hay poster, entonces sigue el código, si no hay poster entonces no crea la pelicula
    .where( (moviedb) => moviedb.posterPath != "no-poster" ) //Where permite poner una condición
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb)
    ).toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    //Obtiene las peliculas por página para que las pelis no se repitan
    final response = await dio.get('/movie/now_playing',
    queryParameters: {
      "page" : page,
    });

    return _jsonToMovies(response.data);

  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    //Obtiene las peliculas por página para que las pelis no se repitan
    final response = await dio.get('/movie/popular',
    queryParameters: {
      "page" : page,
    });

    return _jsonToMovies(response.data);
   
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming',
    queryParameters: {
      "page" : page,
    });

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async{
    final response = await dio.get('/movie/top_rated',
    queryParameters:  {
      "page" : page,
    });

    return _jsonToMovies(response.data);

  }
   
  
  @override
  Future<Movie> getMovieById(String id) async{

    final response = await dio.get('/movie/$id',);

    if ( response.statusCode != 200 ) throw Exception("Movie with id: $id not found");
    
    
    final movieDetails = MovieDetails.fromJson(response.data);
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails );

    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {
    final response = await dio.get('/search/movie',
    
    queryParameters: {
      "query" : query,
    });

    if(query.isEmpty) return [];
      return _jsonToMovies(response.data);
  }
  
  
  
  

}