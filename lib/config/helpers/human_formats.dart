
/** LA FUNCIÓN DE LA CLASE ES REGRESAR UN NÚMERO DADO 
 * CON UN FORMATO EN INGLÉS
 */

import 'package:intl/intl.dart';

class HumanFormats{

  static String number( double number, [ int decimals = 0 ] ){
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: "",
      locale: "en",
    ).format(number);

    return formattedNumber;

  }

  static String dotNumber( double number ){
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 1,
      symbol: "",
      locale: "en",
    ).format(number);

    return formattedNumber;

  }

}