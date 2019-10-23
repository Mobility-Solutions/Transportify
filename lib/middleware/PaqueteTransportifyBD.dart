import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelos/Paquete.dart';
import 'Datos.dart';

class PaqueteTransportifyBD{
  static const String coleccion_paquetes = 'paquetes';

  static const String atributo_nombre="nombre";
  static const String atributo_alto="alto";
  static const String atributo_ancho= "ancho";
  static const String atributo_fragil = "fragil";
  static const String atributo_id_destino = "id_destino";
  static const String atributo_id_origen = "id_origen";
  static const String atributo_id_remitente = "id_remitente";
  static const String atributo_largo = "largo";
  static const String atributo_peso = "peso";
  static const String atributo_precio = "precio";
  static const String atributo_fecha_entrega = "fecha_entrega";

  static String obtenerNombre(DocumentSnapshot snapshot) => snapshot[atributo_nombre];
  static double obtenerAlto(DocumentSnapshot snapshot) => snapshot[atributo_alto];
  static double obtenerAncho(DocumentSnapshot snapshot) => snapshot[atributo_ancho];
  static bool obtenerFragil(DocumentSnapshot snapshot) => snapshot[atributo_fragil];
  static String obtenerIdDestino(DocumentSnapshot snapshot) => snapshot[atributo_id_destino];
  static String obtenerIdOrigen(DocumentSnapshot snapshot) => snapshot[atributo_id_origen];
  static String obtenerIdRemitente(DocumentSnapshot snapshot) => snapshot[atributo_id_remitente];
  static double obtenerLargo(DocumentSnapshot snapshot) => snapshot[atributo_largo];
  static double obtenerPeso(DocumentSnapshot snapshot) => snapshot[atributo_peso];
  static double obtenerPrecio(DocumentSnapshot snapshot) => snapshot[atributo_precio];
  static DateTime obtenerFechaEntrega(DocumentSnapshot snapshot) => snapshot[atributo_fecha_entrega];

  static Map<String, dynamic> paqueteToMap(Paquete paquete) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[atributo_nombre] = paquete.nombre;
    map[atributo_alto] = paquete.alto;
    map[atributo_ancho] = paquete.ancho;
    map[atributo_fragil] = paquete.fragil;
    map[atributo_id_destino] = paquete.destinoId;
    map[atributo_id_origen] = paquete.origenId;
    map[atributo_id_remitente] = paquete.remitenteId;
    map[atributo_largo] = paquete.largo;
    map[atributo_peso] = paquete.peso;
    map[atributo_precio] = paquete.precio;
    map[atributo_fecha_entrega] = paquete.fechaEntrega;
    return map;
  }

  static Future<DocumentReference> crearPaqueteEnBD(Paquete paquete) {
    Map<String, dynamic> entryMap = paqueteToMap(paquete);
    return Datos.crearDocument(coleccion_paquetes, entryMap);
  }
}