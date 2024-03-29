import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';

class PuntoTransportify extends ComponenteBD {
  String apodo;
  String direccion;
  String ciudad;
  double latitud, longitud;

  String get nombre => apodo == null || apodo.isEmpty
      ? direccion == null || direccion.isEmpty
          ? "<punto-sin-nombre>"
          : direccion
      : apodo;

  String get nombreCompleto => "${this.apodo} (${this.direccion})";

  PuntoTransportify.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.apodo = PuntoTransportifyBD.obtenerApodo(snapshot);
    this.direccion = PuntoTransportifyBD.obtenerDireccion(snapshot);
    this.ciudad = PuntoTransportifyBD.obtenerCiudad(snapshot);

    GeoPoint localizacion = PuntoTransportifyBD.obtenerLocalizacion(snapshot);
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    // PuntoTransportify no necesita toMap, ya que sus instancias deben ser inmutables
    return null;
  }

  @override
  Future<void> deleteFromBD() =>
      throw UnsupportedError("Este objeto no se puede borrar de la BD");

  @override
  String toString() => this.nombreCompleto;
}
