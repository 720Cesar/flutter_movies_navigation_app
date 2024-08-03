

import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
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

    

  ],
); 