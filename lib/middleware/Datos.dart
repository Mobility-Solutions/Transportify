import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/util/style.dart';

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
