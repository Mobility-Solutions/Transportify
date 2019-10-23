import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';

class PuntoTransportify {
  String id;
  String nombre;
  String direccion;
  String ciudad;
  double latitud, longitud;

  PuntoTransportify(
      {this.nombre, this.direccion, this.ciudad, this.latitud, this.longitud});

  PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.nombre = PuntoTransportifyBD.obtenerNombre(snapshot);
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
