import 'package:cloud_firestore/cloud_firestore.dart';

import 'Usuario.dart';
import 'PuntoTransportify.dart';

class Viaje {
  String id;
  DateTime fecha;
  String destinoId;
  String origenId;
  String transportistaId;

  Viaje({this.fecha, this.destinoId, this.origenId, this.transportistaId});

  Viaje.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.fecha = snapshot['fecha'];

    this.destinoId = snapshot['id_destino'];
    this.origenId = snapshot['id_origen'];
    this.transportistaId = snapshot['id_transportista'];
  }

}
