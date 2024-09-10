
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource{

  late Future<Isar> db; //La apertura de la DB no es asincrona, por eso "late"

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async{

    //Instancia del directorio en donde se almacena info creada por el usuario o que no puede ser creada por la app
    final dir = await getApplicationDocumentsDirectory();

    if( Isar.instanceNames.isEmpty ){  //Si no hay ninguna instancia...
      //MovieSchema es el esquema creado por el archivo
      return await Isar.open(
        [ MovieSchema ], 
        inspector: true, //Permite obtener un servicio para analizar la BD local
        directory: dir.path
      );
    }

    return Future.value(Isar.getInstance());

  }
  
 //* Las funciones son Async debido a que se debe esperar que la BD esté disponible

  @override
  Future<bool> isMovieFavorite(int movieId) async{
    final isar = await db;
    
    //Guarda el resultado booleano de un query
    final Movie? isFavoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movieId) //El filtro busca aquellas películas con cierto ID
      .findFirst(); //Solo recibe el primer resultado

    return isFavoriteMovie != null; //Si es diferente de nulo, regresa un true

  }

  //REALIZA UNA TRANSACCIÓN (funciones CRUD)
  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();
    
    if( favoriteMovie != null ){
      // Borrar
      //Se pide el ID de la película que le da ISAR debido a que se borra el registro de la BD
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;

    }

    //Insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));

  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;

    return isar.movies.where()
      .offset(offset) //Establece el número de resultados que se muestran después del límite
      .limit(limit) //Establece el número de resultados que encuentra
      .findAll();
  }

}