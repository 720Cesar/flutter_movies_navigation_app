import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});
  
  

  //Crea un Stream de Strings para los mensajes
  Stream<String> getLoadingMessages(){
    final messages = <String>[
      "Cargando películas...",
      "Preparando palomitas...",
      "Esperando estrenos...",
      "¿Esto todavía no termina?...",
      "A este punto ya habría terminado mis palomitas...",
      "Te juramos que no es un error :c"
    ];

    return Stream.periodic( const Duration(milliseconds: 1200), (step){
      return messages[step];
      //take() barrer los mensajes uno por uno
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {



    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Espere por favor", style: TextStyle(
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            fontFamily: "Montserrat"
          ),),
          const SizedBox( height: 10,),
          //const CircularProgressIndicator(strokeWidth: 2,),
          Container(
            width: 350,
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: 
            Lottie.asset("assets/animations/clapperboard_animation.json", animate: true),
          ),
          const SizedBox(height: 10,),

          //Se usa para mostrar las diferentes palabras del arreglo
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot){
              //Si no tiene información
              if( !snapshot.hasData ) return const Text("Cargando...");

              //En este punto si hay data, por eso se agrega !
              return FadeIn(child: Text( snapshot.data! ));
            }
          )

        ],
      ),
    );
  }
}