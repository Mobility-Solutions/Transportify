import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'ComponenteBD.dart';

class Datos {
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderCollectionBD(
      String collectionPath,
      Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return obtenerStreamBuilderCollectionBDFromReference(
        Firestore.instance.collection(collectionPath), builder);
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
        Firestore.instance.document(documentPath), builder);
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

  static Future<DocumentReference> crearDocument(
      String collectionPath, Map<String, dynamic> data) {
    return Firestore.instance.collection(collectionPath).add(data);
  }

  static Future<void> eliminarTodosLosComponentes<T extends ComponenteBD>(
          Iterable<T> listado) =>
      Future.forEach(listado, (componente) => componente.deleteFromBD());
}
