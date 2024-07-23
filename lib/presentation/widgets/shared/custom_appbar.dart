
// CREACIÓN DE UN WIDGET CON UN APPBAR CUSTOMIZADO

import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    
    // Se asigna un área segura por si hay algún obstaculo para renderizar el widget
    return SafeArea(
      bottom: false, //Elimina el espacio de abajo del SafeArea
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 10 ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon( Icons.movie_outlined, color: colors.primary, ),
              const SizedBox( width: 5,),
              Text("CinemaPedia", style: titleStyle,),
              
              //Spacer es un widget que toma todo un espacio disponible
              //En este caso ayuda a mover el texto del título y el ícono de búsqueda
              const Spacer(),
              
              IconButton(
                onPressed: (){

                }, 
                icon: Icon( Icons.search ),
              ),
            ],
          ),
        ),
      )
    );
  }
}