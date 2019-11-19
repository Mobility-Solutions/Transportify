import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:transportify/modelos/Paquete.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/Datos.dart';

import 'PuntosBD.dart';
import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';
import 'package:transportify/modelos/Paquete.dart';

class PaqueteBD {
  static const String coleccion_paquetes = 'paquetes';

  static const String atributo_nombre = "nombre";
  static const String atributo_alto = "alto";
  static const String atributo_ancho = "ancho";
  static const String atributo_fragil = "fragil";
  static const String atributo_destino = PuntosBD.atributo_destino;
  static const String atributo_origen = PuntosBD.atributo_origen;
  static const String atributo_remitente = "remitente";
  static const String atributo_largo = "largo";
  static const String atributo_peso = "peso";
  static const String atributo_precio = "precio";
  static const String atributo_fecha_entrega = "fecha_entrega";
  static const String atributo_estado = 'estado';
  static const String atributo_viaje_asignado = 'viaje';

  static String obtenerNombre(DocumentSnapshot snapshot) =>
      snapshot[atributo_nombre];
  static double obtenerAlto(DocumentSnapshot snapshot) =>
      snapshot[atributo_alto];
  static double obtenerAncho(DocumentSnapshot snapshot) =>
      snapshot[atributo_ancho];
  static bool obtenerFragil(DocumentSnapshot snapshot) =>
      snapshot[atributo_fragil];
  static DocumentReference obtenerDestino(DocumentSnapshot snapshot) =>
      PuntosBD.obtenerDestino(snapshot);
  static DocumentReference obtenerOrigen(DocumentSnapshot snapshot) =>
      PuntosBD.obtenerOrigen(snapshot);
  static DocumentReference obtenerRemitente(DocumentSnapshot snapshot) =>
      snapshot[atributo_remitente];
  static double obtenerLargo(DocumentSnapshot snapshot) =>
      snapshot[atributo_largo];
  static double obtenerPeso(DocumentSnapshot snapshot) =>
      snapshot[atributo_peso];
  static double obtenerPrecio(DocumentSnapshot snapshot) =>
      snapshot[atributo_precio];
  static Timestamp obtenerFechaEntrega(DocumentSnapshot snapshot) =>
      snapshot[atributo_fecha_entrega];
  static EstadoPaquete obtenerEstado(DocumentSnapshot snapshot) {
    int estado = snapshot[atributo_estado];
    return estado == null ? null : EstadoPaquete.values[estado];
  }
  static DocumentReference obtenerViaje(DocumentSnapshot snapshot) =>
      snapshot[atributo_viaje_asignado];

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerListaEnviosBuilder(Function(int estado) onTapMethod) =>
          (context, snapshot) =>
              _obtenerListaPaquetes(context, snapshot, onTapMethod);

  // para todos los paquetes hasta que se haga diferenciación por usuario
  static Widget _obtenerListaPaquetes(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, onTapMethod(int estado)) {
    if (!snapshot.hasData) return const Text('Cargando...');

    return ListView.builder(
      itemBuilder: (context, index) {
        List<Paquete> paquetes = snapshot.data.documents
            .map((document) => Paquete.fromSnapshot(document))
            .where((paquete) => paquete.viajeAsignado != null).toList();
        if (index >= 0 && index < paquetes.length) {
          Paquete paquete = paquetes[index];
          return FutureBuilder(
            future: paquete.waitForInit(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListTile(
                  title: Text(paquete.nombre),
                  onTap: () => onTapMethod(paquete.estado.index),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        } else {
          return null;
        }
      },
    );
  }


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

  static Future<Iterable<Paquete>> obtenerListadoPaquetes()
    => Firestore.instance.collection(coleccion_paquetes).getDocuments().then((snapshot) => snapshot.documents.map((document) => Paquete.fromSnapshot(document)));

  static Widget obtenerListaPaquetes(Function(int estado) onTapMethod) {
    var builder = _obtenerListaEnviosBuilder(onTapMethod);
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_paquetes, builder);
  }

}
