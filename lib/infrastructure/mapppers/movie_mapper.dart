// El mapper tiene como objetivo leer diferentes datos de la API y crear la entidad propia
// que se usará para signar los datos, también se aprovecha para hacer algunas
// validaciones en caso de no existir algún valor esperado.


// Es una capa de protección con la info de la API y la app
// Ejemplo, si "overview" cambia de nombre, aquí se puede cambiar
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {

  static Movie movieDBToEntity( MovieMovideDB moviedb) => Movie(
    adult: moviedb.adult, 
    backdropPath: (moviedb.backdropPath != "") //Evalua si existe una resputesa de imagen
    ? "https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }" //Si lo tiene lo muestra y si no, muestra una imagen en línea
    : "https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg", 
    //Mapea el tipo de datos obtenidos de la API en una lista
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(), 
    id: moviedb.id, 
    originalLanguage: moviedb.originalLanguage, 
    originalTitle: moviedb.originalTitle, 
    overview: moviedb.overview, 
    popularity: moviedb.popularity, 
    posterPath: (moviedb.posterPath != "" )
    ? "https://image.tmdb.org/t/p/w500${ moviedb.posterPath }"
    : "no-poster", 
    releaseDate: moviedb.releaseDate, 
    title: moviedb.title, 
    video: moviedb.video, 
    voteAverage: moviedb.voteAverage, 
    voteCount: moviedb.voteCount
  );


  static Movie movieDetailsToEntity( MovieDetails moviedb ) => Movie(
    adult: moviedb.adult, 
    backdropPath: (moviedb.backdropPath != "") //Evalua si existe una resputesa de imagen
    ? "https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }" //Si lo tiene lo muestra y si no, muestra una imagen en línea
    : "https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg", 
    //Mapea el tipo de datos obtenidos de la API en una lista
    genreIds: moviedb.genres.map((e) => e.name).toList(), 
    id: moviedb.id, 
    originalLanguage: moviedb.originalLanguage, 
    originalTitle: moviedb.originalTitle, 
    overview: moviedb.overview, 
    popularity: moviedb.popularity, 
    posterPath: (moviedb.posterPath != "" )
    ? "https://image.tmdb.org/t/p/w500${ moviedb.posterPath }"
    : "https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg", 
    releaseDate: moviedb.releaseDate, 
    title: moviedb.title, 
    video: moviedb.video, 
    voteAverage: moviedb.voteAverage, 
    voteCount: moviedb.voteCount    
  );

}

