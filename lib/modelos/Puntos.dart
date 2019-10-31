import 'package:transportify/modelos/PuntoTransportify.dart';

class Puntos {
  PuntoTransportify origen, destino;

  Puntos({this.origen, this.destino});

  String validate() {
    if (origen == null || destino == null)
      return 'Introduzca los puntos origen y destino';
    else if (origen == destino)
      return 'Los puntos no deben coincidir.';
    else
      return null;
  }
}
