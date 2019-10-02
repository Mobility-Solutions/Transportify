

import 'package:transportify/modelos/enumerados/FragilidadPaquete.dart';

class Viaje{
  double alto;
  double ancho;
  double largo;
  double peso;
  FragilidadPaquete fragilidad;
  String id_destino;
  String id_origen;
  String id_remitente;
  double precio;

  Viaje(this.alto, this.ancho, this.largo, this.peso, this.fragilidad,
      this.id_destino, this.id_origen, this.id_remitente, this.precio);


}