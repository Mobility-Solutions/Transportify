import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Datos {
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderCollectionBD(
      String collectionPath,
      Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(collectionPath).snapshots(),
      builder: builder,
    );
  }

  static StreamBuilder<DocumentSnapshot> obtenerStreamBuilderDocumentBD(
      String documentPath,
      Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshot>) builder) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.document(documentPath).snapshots(),
      builder: builder,
    );
  }

  static Future<DocumentReference> crearDocument(String collectionPath, Map<String, dynamic> data) {
    return Firestore.instance.collection(collectionPath).add(data);
  }
  
  static Future<void> tratarReferencias(
      Map<String, dynamic> map) async {

    map.forEach((key, value) async {
      if (value is DocumentReference) {
        map[key] = await value.get();
      }
    });
  }
}
