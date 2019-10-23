import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelos/Viaje.dart';
import 'Datos.dart';

class ViajeTransportifyBD{
  static const String coleccion_viajes = 'viajes';
  static const String atributo_id_destino = "id_destino";
  static const String atributo_id_origen = "id_origen";
  static const String atributo_id_transportista = "id_transportista";
  static const String atributo_carga_maxima = "carga_maxima";
  static const String atributo_fecha = "fecha";


  static String obtenerIdDestino(DocumentSnapshot snapshot) => snapshot[atributo_id_destino];
  static String obtenerIdOrigen(DocumentSnapshot snapshot) => snapshot[atributo_id_origen];
  static String obtenerIdTransportista(DocumentSnapshot snapshot) => snapshot[atributo_id_transportista];
  static double obtenerCargaMaxima(DocumentSnapshot snapshot) => snapshot[atributo_carga_maxima];
  static DateTime obtenerFecha(DocumentSnapshot snapshot) => snapshot[atributo_fecha];

  static Map<String, dynamic> viajeToMap(Viaje viaje) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[atributo_id_destino] = viaje.destinoId;
    map[atributo_id_origen] = viaje.origenId;
    map[atributo_id_transportista] = viaje.transportistaId;
    map[atributo_carga_maxima] = viaje.cargaMaxima;
    map[atributo_fecha] = viaje.fecha;
    return map;
  }

  static Future<DocumentReference> crearViajeEnBD(Viaje viaje) {
    Map<String, dynamic> entryMap = viajeToMap(viaje);
    return Datos.crearDocument(coleccion_viajes, entryMap);
  }
}