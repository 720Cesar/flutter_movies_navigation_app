import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {

  static const name = 'splash-screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    //Permite que se abarque la totalidad de la pantalla
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    //Permite una duración de 2 segundos para que inicie la pantalla principal
    Future.delayed(const Duration(seconds: 2), () {
      context.go("/home/0");
    });
  }

  @override
  void dispose() {
    //Se elimina la pantalla completa después del Splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/splash_background.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeIn(child: Image.asset("assets/images/splash_logo.png",))
            ],
          ),
        ]
      ),  
    );
  }
}