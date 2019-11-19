import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static DocumentReference obtenerDestino(DocumentSnapshot snapshot) => PuntosBD.obtenerDestino(snapshot);
  static DocumentReference obtenerOrigen(DocumentSnapshot snapshot) => PuntosBD.obtenerOrigen(snapshot);
  static DocumentReference obtenerTransportista(DocumentSnapshot snapshot) =>
      snapshot[atributo_transportista];
  static double obtenerCargaMaxima(DocumentSnapshot snapshot) =>
      snapshot[atributo_carga_maxima];
  static Timestamp obtenerFecha(DocumentSnapshot snapshot) =>
      snapshot[atributo_fecha];
/** 
  static Future<Iterable<Viaje>> obtenerListadoViajes()
    => Firestore.instance.collection(coleccion_viajes).getDocuments().then((snapshot) => snapshot.documents.map((document) => Viaje.fromSnapshot(document)));
*/
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_viajes, builder);
  }

  static Widget obtenerListadoViajes({Function(Viaje) onSelected}) {
    return obtenerStreamBuilderListado(
        _obtenerListadoViajesBuilder(onSelected));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerListadoViajesBuilder(Function(Viaje) onSelected) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerListadoViajes(context, snapshot, onSelected);
    };
  }

  static Widget _obtenerListadoViajes(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, Function(Viaje) onSelected) {
    if (!snapshot.hasData) return const Text('Cargando...');

    var viajes = snapshot.data.documents;

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index >= 0 && index < viajes.length) {
          var usuario = viajes.elementAt(index);
          return _obtenerListViewItemViaje(usuario, onSelected);
        } else {
          return null;
        }
      },
    );


  }

  static Widget _obtenerListViewItemViaje(
      DocumentSnapshot snapshot, Function(Viaje) onSelected) {
    Viaje viaje = Viaje.fromSnapshot(snapshot);

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(viaje);
    }

    return ListTile(
      title: Text("Origen - Destino: " + viaje.origen.toString() + " - " + viaje.destino.toString()),
      onTap: onTap,
    );
  }

}
