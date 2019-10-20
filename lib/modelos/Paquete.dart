import 'package:cloud_firestore/cloud_firestore.dart';

import 'PuntoTransportify.dart';
import 'Usuario.dart';

class Paquete {
  String id;
  String nombre;
  double largo, ancho, alto;
  double peso;
  bool fragil;
  String destinoId;
  String origenId;
  String remitenteId;
  double precio;
  DateTime fechaEntrega;

  Paquete(
      {this.nombre,
      this.alto,
      this.ancho,
      this.largo,
      this.peso,
      this.fragil,
      this.destinoId,
      this.origenId,
      this.remitenteId,
      this.precio,
      this.fechaEntrega});

  Paquete.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.nombre = snapshot['nombre'];
    this.largo = snapshot['largo'];
    this.ancho = snapshot['ancho'];
    this.alto = snapshot['alto'];
    this.peso = snapshot['peso'];
    this.fragil = snapshot['fragil'];
    this.precio = snapshot['precio'];

    this.destinoId = snapshot['id_destino'];
    this.origenId = snapshot['id_origen'];
    this.remitenteId = snapshot['id_remitente'];
    this.fechaEntrega = snapshot['fecha_entrega'];
  }
}


