
import 'package:cloud_firestore/cloud_firestore.dart';

class PuntoTransportify {
  String nombre;
  String direccion;
  double latitud, longitud;

  PuntoTransportify({this.nombre, this.direccion, this.latitud, this.longitud});

  PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) {
    this.nombre = snapshot['nombre'];
    this.direccion = snapshot['direccion'];

    GeoPoint localizacion = snapshot['localizacion'];
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
  }
  
}
