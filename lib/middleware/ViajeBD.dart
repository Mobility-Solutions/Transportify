import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/modelos/Viaje.dart';

import 'PuntosBD.dart';

class ViajeBD {
  static const String coleccion_viajes = 'viajes';
  static const String atributo_destino = PuntosBD.atributo_destino;
  static const String atributo_origen = PuntosBD.atributo_origen;
  static const String atributo_transportista = "transportista";
  static const String atributo_carga_maxima = "carga_maxima";
  static const String atributo_fecha = "fecha";

  static DocumentReference obtenerDestino(DocumentSnapshot snapshot) => PuntosBD.obtenerDestino(snapshot);
  static DocumentReference obtenerOrigen(DocumentSnapshot snapshot) => PuntosBD.obtenerOrigen(snapshot);
  static DocumentReference obtenerTransportista(DocumentSnapshot snapshot) =>
      snapshot[atributo_transportista];
  static double obtenerCargaMaxima(DocumentSnapshot snapshot) =>
      snapshot[atributo_carga_maxima];
  static Timestamp obtenerFecha(DocumentSnapshot snapshot) =>
      snapshot[atributo_fecha];

  static Future<Iterable<Viaje>> obtenerListadoViajes()
    => Firestore.instance.collection(coleccion_viajes).getDocuments().then((snapshot) => snapshot.documents.map((document) => Viaje.fromSnapshot(document)));
}
