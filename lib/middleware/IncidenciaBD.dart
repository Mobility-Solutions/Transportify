import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Incidencia.dart';
import 'Datos.dart';

class IncidenciaBD {
  static const String coleccion_incidencias = 'incidencias';
  static const String atributo_descripcion = "descripcion";
  static const String atributo_retrasoHoras = "retrasoHoras";

  static String obtenerDescripcion(DocumentSnapshot snapshot) =>
      snapshot[atributo_descripcion];
  static int obtenerRetrasoHoras(DocumentSnapshot snapshot) =>
      snapshot[atributo_retrasoHoras];

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_incidencias, builder);
  }

  static Future<Iterable<Incidencia>> obtenerListadoIncidencias() => Firestore.instance
      .collection(coleccion_incidencias)
      .getDocuments()
      .then((snapshot) =>
          snapshot.documents.map((document) => Incidencia.fromSnapshot(document)));
}
