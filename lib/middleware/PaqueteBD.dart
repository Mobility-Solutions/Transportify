import 'package:cloud_firestore/cloud_firestore.dart';

import 'PuntosBD.dart';

class PaqueteBD {
  static const String coleccion_paquetes = 'paquetes';

  static const String atributo_nombre="nombre";
  static const String atributo_alto="alto";
  static const String atributo_ancho= "ancho";
  static const String atributo_fragil = "fragil";
  static const String atributo_destino = PuntosBD.atributo_destino;
  static const String atributo_origen = PuntosBD.atributo_origen;
  static const String atributo_remitente = "remitente";
  static const String atributo_largo = "largo";
  static const String atributo_peso = "peso";
  static const String atributo_precio = "precio";
  static const String atributo_fecha_entrega = "fecha_entrega";

  static String obtenerNombre(DocumentSnapshot snapshot) => snapshot[atributo_nombre];
  static double obtenerAlto(DocumentSnapshot snapshot) => snapshot[atributo_alto];
  static double obtenerAncho(DocumentSnapshot snapshot) => snapshot[atributo_ancho];
  static bool obtenerFragil(DocumentSnapshot snapshot) => snapshot[atributo_fragil];
  static DocumentReference obtenerDestino(DocumentSnapshot snapshot) => PuntosBD.obtenerDestino(snapshot);
  static DocumentReference obtenerOrigen(DocumentSnapshot snapshot) => PuntosBD.obtenerOrigen(snapshot);
  static DocumentReference obtenerRemitente(DocumentSnapshot snapshot) => snapshot[atributo_remitente];
  static double obtenerLargo(DocumentSnapshot snapshot) => snapshot[atributo_largo];
  static double obtenerPeso(DocumentSnapshot snapshot) => snapshot[atributo_peso];
  static double obtenerPrecio(DocumentSnapshot snapshot) => snapshot[atributo_precio];
  static Timestamp obtenerFechaEntrega(DocumentSnapshot snapshot) => snapshot[atributo_fecha_entrega];
}
