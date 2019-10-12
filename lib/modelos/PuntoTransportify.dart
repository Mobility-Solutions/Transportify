
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
  
}
