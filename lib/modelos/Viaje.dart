import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/ViajeTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

import 'Usuario.dart';

class Viaje extends ComponenteBD {
  double cargaMaxima;
  DateTime fecha;
  PuntoTransportify destino;
  PuntoTransportify origen;
  Usuario transportista;

  Viaje(
      {this.cargaMaxima,
      this.fecha,
      this.destino,
      this.origen,
      this.transportista});

  Viaje.fromReference(DocumentReference reference)
      : super.fromReference(reference);

  Viaje.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.cargaMaxima = snapshot[ViajeTransportifyBD.atributo_carga_maxima];
    this.fecha = snapshot[ViajeTransportifyBD.atributo_fecha];
    this.destino = PuntoTransportify.fromReference(snapshot[ViajeTransportifyBD.atributo_destino]);
    this.origen = PuntoTransportify.fromReference(snapshot[ViajeTransportifyBD.atributo_origen]);
    this.transportista = Usuario.fromReference(snapshot[ViajeTransportifyBD.atributo_transportista]);

    await Future.wait([this.destino.waitForInit(), this.origen.waitForInit(), this.transportista.waitForInit()]);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[ViajeTransportifyBD.atributo_destino] = this.destino;
    map[ViajeTransportifyBD.atributo_origen] = this.origen;
    map[ViajeTransportifyBD.atributo_transportista] = this.transportista;
    map[ViajeTransportifyBD.atributo_carga_maxima] = this.cargaMaxima;
    map[ViajeTransportifyBD.atributo_fecha] = this.fecha;
    return map;
  }
}
