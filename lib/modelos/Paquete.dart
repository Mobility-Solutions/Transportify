import 'PuntoTransportify.dart';
import 'Usuario.dart';

class Viaje {
  double largo, ancho, alto;
  double peso;
  bool fragil;
  PuntoTransportify destino;
  PuntoTransportify origen;
  Usuario remitente;
  double precio;

  Viaje(
      {this.alto,
      this.ancho,
      this.largo,
      this.peso,
      this.fragil,
      this.destino,
      this.origen,
      this.remitente,
      this.precio});
}
