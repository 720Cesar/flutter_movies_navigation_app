

import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: "/home/0",
  routes: [
    GoRoute(
      path: "/home/:page",
      name: HomeScreen.name,
      builder: (context, state) {
        //Se obtiene el valor de "page" y 
        final pageIndex = (state.pathParameters['page' ?? 0]).toString(); //En caso de no haber "page", se manda 0

        return HomeScreen( pageIndex: int.parse(pageIndex) ,); //Se hace el parseo a int
      },
      //Se conoce como rutas hijas
      //Colocar las otras pantallas como rutas hijas permite el Deep-Linking en la aplicación
      routes: [

        GoRoute(
          //"/:id" Envia el argumento "ID", siempre recibe Strings
          path: "movie/:id",
          name: MovieScreen.name,
          builder: (context, state) {
            
            //Recibe el parámetro ID del estado, en caso de no haber devuelve un "no-id"
            final movieId = state.pathParameters["id"] ?? "no-id";

            return MovieScreen(movieId: movieId);
          },
        ),

      ]
    ),

    //Se establece que la ruta "/" siempre redirija a la ruta "/home/0/movie"
    GoRoute(
      path: '/',
      redirect: ( _, __ ) => '/home/0', //"_" y "__" funciona como nombre de variable para indicar que no importa lo que se manda
    ), 

  ],
); 