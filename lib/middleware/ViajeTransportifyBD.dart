import 'package:cloud_firestore/cloud_firestore.dart';

class ViajeTransportifyBD {
  static const String coleccion_viajes = 'viajes';
  static const String atributo_destino = "destino";
  static const String atributo_origen = "origen";
  static const String atributo_transportista = "transportista";
  static const String atributo_carga_maxima = "carga_maxima";
  static const String atributo_fecha = "fecha";

  static DocumentReference obtenerDestino(DocumentSnapshot snapshot) =>
      snapshot[atributo_destino];
  static DocumentReference obtenerOrigen(DocumentSnapshot snapshot) =>
      snapshot[atributo_origen];
  static DocumentReference obtenerTransportista(DocumentSnapshot snapshot) =>
      snapshot[atributo_transportista];
  static double obtenerCargaMaxima(DocumentSnapshot snapshot) =>
      snapshot[atributo_carga_maxima];
  static Timestamp obtenerFecha(DocumentSnapshot snapshot) =>
      snapshot[atributo_fecha];
}
