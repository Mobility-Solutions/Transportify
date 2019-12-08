import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:transportify/modelos/Paquete.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/modelos/Usuario.dart';

import 'PuntosBD.dart';
import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';

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
  static const String atributo_dias_margen = "dias_margen";

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
  static int obtenerDiasMargen(DocumentSnapshot snapshot) =>
      snapshot[atributo_dias_margen];
  static EstadoPaquete obtenerEstado(DocumentSnapshot snapshot) {
    int estado = snapshot[atributo_estado];
    return estado == null ? null : EstadoPaquete.values[estado];
  }

  static DocumentReference obtenerViaje(DocumentSnapshot snapshot) =>
      snapshot[atributo_viaje_asignado];

  static Future<Iterable<Paquete>> obtenerListadoPaquetes() => Firestore
      .instance
      .collection(coleccion_paquetes)
      .getDocuments()
      .then((snapshot) =>
          snapshot.documents.map((document) => Paquete.fromSnapshot(document)));

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_paquetes, builder);
  }

  static Widget obtenerListadoPaquetesWidget(
      {Usuario usuario, onSelected(int estado)}) {
    var builder = _obtenerListaEnviosBuilder(usuario, onSelected);
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_paquetes, builder);
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerListaEnviosBuilder(Usuario usuario, onTapMethod(int estado)) =>
          (context, snapshot) =>
              _obtenerListaPaquetes(context, snapshot, usuario, onTapMethod);

  static Widget _obtenerListaPaquetes(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Usuario usuario,
      onTapMethod(int estado)) {
    if (!snapshot.hasData)
      return const Center(child: const CircularProgressIndicator());

    return ListView.builder(
      itemBuilder: (context, index) {
        List<Paquete> paquetes = snapshot.data.documents
            .map((document) => Paquete.fromSnapshot(document))
            .where((paquete) =>
                paquete.viajeAsignado != null &&
                (usuario == null || paquete.remitente == usuario))
            .toList();
        if (index >= 0 && index < paquetes.length) {
          Paquete paquete = paquetes[index];
          return FutureBuilder(
            future: paquete.waitForInit(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _obtenerListViewItemPaquete(
                  paquete: paquete,
                  onSelected: (paquete) => onTapMethod(paquete.estado.index),
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

  static Widget _obtenerListViewItemPaquete(
      {@required Paquete paquete, Function(Paquete) onSelected}) {
    String ciudadOrigen = paquete.origen?.ciudad ?? "¿?",
        ciudadDestino = paquete.destino?.ciudad ?? "¿?";

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(paquete);
    }

    String fechaEntregaConFormato =
        DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, "es_ES")
            .format(paquete.fechaEntrega);

    return ListTile(
      title: Text(
          "${paquete.nombre} ($fechaEntregaConFormato) ($ciudadOrigen -> $ciudadDestino)"),
      onTap: onTap,
    );
  }

  static Widget obtenerListaCardsPaquetes(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData)
      return const Center(child: const CircularProgressIndicator());

    var paquetes = snapshot.data.documents;

    return ListView.builder(itemBuilder: (context, index) {
      if (index >= 0 && index < paquetes.length) {
        var paquete = paquetes.elementAt(index);
        return _obtenerCardPaquete(paquete);
      } else {
        return null;
      }
    });
  }

  static Widget _obtenerCardPaquete(DocumentSnapshot snapshot) {
    Paquete paquete = Paquete.fromSnapshot(snapshot);

    return Card(
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://www.shareicon.net/data/512x512/2015/09/30/648924_boxes_512x512.png"))),
          ),
          Container(
            height: 100,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(paquete.nombre),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
