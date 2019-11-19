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

  static String obtenerDestino(DocumentSnapshot snapshot) => snapshot[atributo_destino];
  static String obtenerOrigen(DocumentSnapshot snapshot) => snapshot[atributo_origen];
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

  static Widget obtenerListadoViajesWidget({Function(Viaje) onSelected, bool Function(Viaje) filtro}) {
    return obtenerStreamBuilderListado(
        _obtenerListadoViajesBuilder(onSelected, filtro));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerListadoViajesBuilder(Function(Viaje) onSelected, bool Function(Viaje) filtro) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerListadoViajes(context, snapshot, onSelected, filtro);
    };
  }

  static Widget _obtenerListadoViajes(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, Function(Viaje) onSelected, bool Function(Viaje) filtro) {
    if (!snapshot.hasData) return const Text('Cargando...');

    var viajes = snapshot.data.documents;

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index >= 0 && index < viajes.length) {
          Viaje viaje = Viaje.fromSnapshot(viajes.elementAt(index));
          if (filtro == null || filtro(viaje)) {
            return _obtenerListViewItemViaje(viaje, onSelected);
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
    );
  }

  static Widget _obtenerListViewItemViaje(
      Viaje viaje, Function(Viaje) onSelected) {
    String ciudadOrigen, ciudadDestino;

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(viaje);
    }
    if(viaje.origen == null) {
      ciudadOrigen = "Sin ciudad";
    } else {
      ciudadOrigen = viaje.origen;
    }
    if(viaje.destino == null) {
      ciudadDestino = "Sin ciudad";
    }else {
      ciudadDestino = viaje.destino;
    }

    return ListTile(
      title: Text("Viaje desde " + ciudadOrigen + " a " + ciudadDestino + ", con fecha: " + viaje.fecha.day.toString() + "/" + viaje.fecha.month.toString() + "/" + viaje.fecha.year.toString() +"."),
      onTap: onTap,
    );
  }


  static Future<Iterable<Viaje>> obtenerListadoViajes()
    => Firestore.instance.collection(coleccion_viajes).getDocuments().then((snapshot) => snapshot.documents.map((document) => Viaje.fromSnapshot(document)));

}
