import 'package:cloud_firestore/cloud_firestore.dart';

import 'Paquete.dart';
import 'Viaje.dart';
import 'enumerados/EstadoPaquete.dart';

class Envio {
  String id;
  EstadoPaquete estado;
  String paqueteId;
  String viajeId;

  Envio({this.estado, this.paqueteId, this.viajeId});

  Envio.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.estado = snapshot['estado'];
    this.paqueteId = snapshot['id_paquete'];
    this.viajeId = snapshot['id_viaje'];
  }

}
