
/** ARCHIVO QUE PERMITE OBTENER UN NÚMERO DE FECHA 
 * Y TRADUCIRLO AL ESPAÑOL
 */

class SpanishDates {

  static String monthES( int month ){

    String mes = "";    

    switch(month){
      case 1:
        mes = "Enero";
        break;
      case 2:
        mes = "Febrero";
        break;
      case 3:
        mes = "Marzo";
        break;
      case 4:
        mes = "Abril";
        break;
      case 5:
        mes = "Mayo";
        break;
      case 6:
        mes = "Junio";
        break;
      case 7:
        mes = "Julio";
        break;
      case 8:
        mes = "Agosto";
        break;
      case 9:
        mes = "Septiembre";
        break;
      case 10:
        mes = "Octubre";
        break;
      case 11:
        mes = "Noviembre";
        break;
      case 12:
        mes = "Diciembre";
        break;
      default:
        mes = "Fuera de rango";
        break;
    }

    return mes;

  }

}