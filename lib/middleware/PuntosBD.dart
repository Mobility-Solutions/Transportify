import 'package:cloud_firestore/cloud_firestore.dart';

class PuntosBD {
  static const String atributo_destino = "destino";
  static const String atributo_origen = "origen";

  static DocumentReference obtenerDestino(DocumentSnapshot snapshot) => snapshot[atributo_destino];
  static DocumentReference obtenerOrigen(DocumentSnapshot snapshot) => snapshot[atributo_origen];
}