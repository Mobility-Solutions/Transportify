import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';

import 'Datos.dart';
import 'PuntosBD.dart';

class ViajeBD {
  static const String coleccion_viajes = 'viajes';
  static const String atributo_destino = PuntosBD.atributo_destino;
  static const String atributo_origen = PuntosBD.atributo_origen;
  static const String atributo_transportista = "transportista";
  static const String atributo_carga_maxima = "carga_maxima";
  static const String atributo_fecha = "fecha";

  static String obtenerDestino(DocumentSnapshot snapshot) =>
      snapshot[atributo_destino];
  static String obtenerOrigen(DocumentSnapshot snapshot) =>
      snapshot[atributo_origen];
  static DocumentReference obtenerTransportista(DocumentSnapshot snapshot) =>
      snapshot[atributo_transportista];
  static double obtenerCargaMaxima(DocumentSnapshot snapshot) =>
      snapshot[atributo_carga_maxima];
  static Timestamp obtenerFecha(DocumentSnapshot snapshot) =>
      snapshot[atributo_fecha];

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_viajes, builder);
  }

  static Widget obtenerListadoViajesWidget(
      {Function(Viaje) onSelected,
      Widget showOnEmpty,
      bool Function(Viaje) filtro,
      Usuario usuario}) {
    return obtenerStreamBuilderListado(
        _obtenerListadoViajesBuilder(onSelected, showOnEmpty, filtro, usuario));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerListadoViajesBuilder(
    Function(Viaje) onSelected,
    Widget showOnEmpty,
    bool Function(Viaje) filtro,
    Usuario usuario,
  ) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerListadoViajesWidget(
          context, snapshot, onSelected, showOnEmpty, filtro, usuario);
    };
  }

  static Widget _obtenerListadoViajesWidget(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot,
    Function(Viaje) onSelected,
    Widget showOnEmpty,
    bool Function(Viaje) filtro,
    Usuario usuario,
  ) {
    if (!snapshot.hasData)
      return const Center(child: const CircularProgressIndicator());

    var viajes = snapshot.data.documents
        .map((snapshot) => Viaje.fromSnapshot(snapshot))
        .where((viaje) =>
            (usuario == null || viaje.transportista == usuario) &&
            (filtro == null || filtro(viaje)));

    return showOnEmpty != null && viajes.isEmpty
        ? showOnEmpty
        : ListView.builder(
            itemCount: viajes.length,
            itemBuilder: (context, index) {
              Viaje viaje = viajes.elementAt(index);
              return _obtenerListViewItemViaje(viaje, onSelected);
            },
          );
  }

  static Widget _obtenerListViewItemViaje(
      Viaje viaje, Function(Viaje) onSelected) {
    String ciudadOrigen = viaje.origen ?? "¿?",
        ciudadDestino = viaje.destino ?? "¿?";

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(viaje);
    }

    String fechaEntregaConFormato =
        DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, "es_ES")
            .format(viaje.fecha);

    return ListTile(
      title: Text("$fechaEntregaConFormato ($ciudadOrigen -> $ciudadDestino)"),
      onTap: onTap,
    );
  }

  static Future<Iterable<Viaje>> obtenerListadoViajes() => Firestore.instance
      .collection(coleccion_viajes)
      .getDocuments()
      .then((snapshot) =>
          snapshot.documents.map((document) => Viaje.fromSnapshot(document)));
}
