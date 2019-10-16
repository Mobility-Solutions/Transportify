import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Datos {
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderCollectionBD(
      String collection,
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(collection).snapshots(),
      builder: builder,
    );
  }

  static StreamBuilder<DocumentSnapshot> obtenerStreamBuilderDocumentBD(
      String path,
      Function(BuildContext, AsyncSnapshot<DocumentSnapshot>) builder) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.document(path).snapshots(),
      builder: builder,
    );
  }
}
