import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';

class PuntoTransportify {
  String id;
  String apodo;
  String direccion;
  String ciudad;
  double latitud, longitud;

  String get nombre => apodo == null || apodo.isEmpty
      ? direccion == null || direccion.isEmpty
          ? "<punto-sin-nombre>"
          : direccion
      : apodo;

  PuntoTransportify(
      {this.apodo, this.direccion, this.ciudad, this.latitud, this.longitud});

  PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.apodo = PuntoTransportifyBD.obtenerApodo(snapshot);
    this.direccion = PuntoTransportifyBD.obtenerDireccion(snapshot);
    this.ciudad = PuntoTransportifyBD.obtenerCiudad(snapshot);

    GeoPoint localizacion = PuntoTransportifyBD.obtenerLocalizacion(snapshot);
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
  }

  @override
  bool operator ==(o) => o is PuntoTransportify && o.id == id;

  @override
  int get hashCode => id.hashCode;
}
