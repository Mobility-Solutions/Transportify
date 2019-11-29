import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/util/style.dart';

import 'ComponenteBD.dart';

class Datos {
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderCollectionBD(
      String collectionPath,
      Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return obtenerStreamBuilderCollectionBDFromReference(
        obtenerColeccion(collectionPath), builder);
  }

  static StreamBuilder<QuerySnapshot>
      obtenerStreamBuilderCollectionBDFromReference(
          CollectionReference collectionReference,
          Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference.snapshots(),
      builder: builder,
    );
  }

  static StreamBuilder<DocumentSnapshot> obtenerStreamBuilderDocumentBD(
      String documentPath,
      Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshot>) builder) {
    return obtenerStreamBuilderDocumentBDFromReference(
        obtenerDocumento(documentPath), builder);
  }

  static StreamBuilder<DocumentSnapshot>
      obtenerStreamBuilderDocumentBDFromReference(
          DocumentReference documentReference,
          Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshot>)
              builder) {
    return StreamBuilder<DocumentSnapshot>(
      stream: documentReference.snapshots(),
      builder: builder,
    );
  }

  static CollectionReference obtenerColeccion(String collectionPath) => Firestore.instance.collection(collectionPath);
  static DocumentReference obtenerDocumento(String documentPath) => Firestore.instance.document(documentPath); 

  static Future<DocumentReference> crearDocument(
      String collectionPath, Map<String, dynamic> data) {
    return Firestore.instance.collection(collectionPath).add(data);
  }

  static Future<void> eliminarTodosLosComponentes<T extends ComponenteBD>(
          Iterable<T> listado) =>
      Future.forEach(listado, (componente) => componente.deleteFromBD());

  static Widget obtenerListViewItem<T>(
      {T item,
      String displayName,
      bool selected = false,
      Function(T) onSelected}) {
    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(item);
    }

    return Container(
      color: selected ? TransportifyColors.primarySwatch : null,
      child: ListTile(
        title: Text(
          displayName,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

}
