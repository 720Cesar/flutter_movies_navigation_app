

import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(
      
      path: "/home/:page",
      name: HomeScreen.name,
      pageBuilder: (context, state) {

        final pageIndex = (state.pathParameters['page' ?? 0]).toString();

        return CustomTransitionPage(
          transitionDuration: const Duration(seconds: 2),
          key: state.pageKey,
          child:  HomeScreen(pageIndex: int.parse(pageIndex),), 
          transitionsBuilder: (context, animation, secondaryAnimation, child){
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }
        );
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

    GoRoute(
      path: "/splash",
      name: SplashScreen.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(seconds: 3),
          key: state.pageKey,
          child: const SplashScreen(), 
          transitionsBuilder: (context, animation, secondaryAnimation, child){
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }
        );
      }
    ),

    //Se establece que la ruta "/" siempre redirija a la ruta "/home/0/movie"
    GoRoute(
      path: '/',
      redirect: ( _, __ ) => '/home/0', //"_" y "__" funciona como nombre de variable para indicar que no importa lo que se manda
    ), 

  ],
); 