import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/**
 * PROVIDER QUE DEVUELVE TRUE O FALSE DEPENDIENDO DE SI LOS DEMÁS PROVIDERS TIENEN DATOS
 */

final initialLoadingProvider = Provider<bool>((ref){

  //Se evalua si están vacíos los providers
  final step1 = ref.watch( nowPlayingMoviesProvider ).isEmpty;
  final step2 = ref.watch( popularMoviesProvider ).isEmpty;
  final step3 = ref.watch( upcomingMoviesProvider ).isEmpty;
  final step4 = ref.watch( topRatedMoviesProvider ).isEmpty;

  //Si alguno de esos está vacío, entonces estoy cargando y regreso true
  if(step1 || step2 || step3 || step4) return true;
  
  //Si todos están llenos de data (Son false), entonces regreso false
  return false; //Se termina de cargar la data de los otros Providers
});