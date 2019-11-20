import 'package:transportify/modelos/PuntoTransportify.dart';

class Puntos {
  PuntoTransportify origen, destino;

  Puntos({this.origen, this.destino});

  @override
  bool operator ==(o) => o is Puntos && origen == o?.origen && destino == o?.destino;

  @override
  int get hashCode => origen.hashCode - destino.hashCode;

  String validate() {
    if (origen == null || destino == null)
      return 'Introduzca los puntos origen y destino';
    else if (origen == destino)
      return 'Los puntos no deben coincidir.';
    else
      return null;
  }
}
