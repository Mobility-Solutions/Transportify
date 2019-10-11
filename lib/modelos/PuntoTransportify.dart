
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PuntoTransportify {
  String id;
  String nombre;
  String direccion;
  double latitud, longitud;

  PuntoTransportify({this.nombre, this.direccion, this.latitud, this.longitud});

  PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.nombre = snapshot['nombre'];
    this.direccion = snapshot['direccion'];

    GeoPoint localizacion = snapshot['localizacion'];
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
  }

  @override
  bool operator ==(o) => o is PuntoTransportify && o.id == id;

  @override
  int get hashCode => id.hashCode;

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return obtenerStreamBuilderCollectionBD('puntos_transportify', builder);
  }

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderCollectionBD(String collection, Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(collection).snapshots(),
      builder: builder
    );
  }

  static StreamBuilder<DocumentSnapshot> obtenerStreamBuilderDocumentBD(String path, Function(BuildContext, AsyncSnapshot<DocumentSnapshot>) builder) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.document(path).snapshots(),
      builder: builder
    );
  }

  static Widget obtenerDropDown({Function(dynamic) onChanged, dynamic value}) {
    return obtenerStreamBuilderListado(_obtenerDropDownBuilder(onChanged, value));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>) _obtenerDropDownBuilder(Function(dynamic) onChanged, dynamic value) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerDropDown(context, snapshot, onChanged, value);
    };
  }

  static Widget _obtenerDropDown(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, Function(dynamic) onChanged, dynamic value) {
    if (!snapshot.hasData) return const Text('Cargando...');

    List<DropdownMenuItem> items = new List<DropdownMenuItem>();
    for (DocumentSnapshot document in snapshot.data.documents) {
      items.add(_obtenerDropDownMenuItem(document));
    }
    
    return DropdownButton(
      items: items,
      onChanged: onChanged,
      value: value
    );
  }

  static DropdownMenuItem _obtenerDropDownMenuItem(DocumentSnapshot snapshot) {
    PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);
    return DropdownMenuItem(
      child: Text(punto?.nombre ?? ""),
      value: punto,
    );
  }
  
}
