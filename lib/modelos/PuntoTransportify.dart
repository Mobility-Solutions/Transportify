
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

  static StreamBuilder obtenerStreamBuilderListado(Function(BuildContext, AsyncSnapshot<dynamic>) builder) {
    return StreamBuilder(
      stream: Firestore.instance.collection('puntos_transportify').snapshots(),
      builder: builder
    );
  }

  static Widget obtenerDropDown({Function(dynamic) onChanged, dynamic value}) {
    return obtenerStreamBuilderListado(_obtenerDropDownBuilder(onChanged, value));
  }

  static Function(BuildContext, AsyncSnapshot<dynamic>) _obtenerDropDownBuilder(Function(dynamic) onChanged, dynamic value) {
    return (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      return _obtenerDropDown(context, snapshot, onChanged, value);
    };
  }

  static Widget _obtenerDropDown(BuildContext context, AsyncSnapshot<dynamic> snapshot, Function(dynamic) onChanged, dynamic value) {
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
