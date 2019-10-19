import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelos/Paquete.dart';
import 'Datos.dart';

class PaqueteTransportify{
  static const String atributo_alto="alto";
  static const String atributo_ancho= "ancho";
  static const String atributo_fragil = "fragil";
  static const String atributo_id_destino = "id_destino";
  static const String atributo_id_origen = "id_origen";
  static const String atributo_id_remitente = "id_remitente";
  static const String atributo_largo = "largo";
  static const String atributo_peso = "peso";
  static const String atributo_precio = "precio";

  static const String coleccion_paquetes = 'paquetes';

  static Map<String, dynamic> paqueteToMap(Paquete paquete) {
    Map<String, dynamic> map = Map<String, dynamic>();

    map[atributo_alto] = paquete.alto;
    map[atributo_ancho] = paquete.ancho;
    map[atributo_fragil] = paquete.fragil;
    map[atributo_id_destino] = paquete.destinoId;
    map[atributo_id_origen] = paquete.origenId;
    map[atributo_id_remitente] = paquete.remitenteId;
    map[atributo_largo] = paquete.largo;
    map[atributo_peso] = paquete.peso;
    map[atributo_precio] = paquete.precio;
    return map;
  }

  static Future<DocumentReference> crearPaqueteEnBD(Paquete paquete) {
    Map<String, dynamic> entryMap = paqueteToMap(paquete);
    return Datos.crearDocument(coleccion_paquetes, entryMap);
  }
}