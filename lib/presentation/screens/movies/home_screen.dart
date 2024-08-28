import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  static const name = "home-screen";
  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });


  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(), //<----- CategoriesView
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: IndexedStack( //Permite mantener el estado al cambiar entre pestañas
        index: pageIndex,   
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex,),
    );
  }
}

