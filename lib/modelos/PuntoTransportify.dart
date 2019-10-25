import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';

class PuntoTransportify extends ComponenteBD {
  String nombre;
  String direccion;
  String ciudad;
  double latitud, longitud;

  PuntoTransportify(
      {this.nombre, this.direccion, this.ciudad, this.latitud, this.longitud});

  PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);

  @override
  void loadFromSnapshot(DocumentSnapshot snapshot) {
    super.loadFromSnapshot(snapshot);
    
    this.nombre = PuntoTransportifyBD.obtenerNombre(snapshot);
    this.direccion = PuntoTransportifyBD.obtenerDireccion(snapshot);
    this.ciudad = PuntoTransportifyBD.obtenerCiudad(snapshot);

    GeoPoint localizacion = PuntoTransportifyBD.obtenerLocalizacion(snapshot);
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
  }

  @override
  Map<String, dynamic> toMap() {
    // PuntoTransportify no necesita toMap, ya que sus instancias deben ser read-only
    return null;
  }

  @override
  Future<void> deleteFromBD() => throw UnsupportedError("Este objeto no se puede borrar de la BD");

}
