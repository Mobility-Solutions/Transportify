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
      this.transportista}) : super(coleccion: ViajeTransportifyBD.coleccion_viajes);

  Viaje.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Viaje.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.cargaMaxima = ViajeTransportifyBD.obtenerCargaMaxima(snapshot);
    this.fecha = ViajeTransportifyBD.obtenerFecha(snapshot).toDate();
    this.destino = PuntoTransportify.fromReference(ViajeTransportifyBD.obtenerDestino(snapshot));
    this.origen = PuntoTransportify.fromReference(ViajeTransportifyBD.obtenerOrigen(snapshot));
    this.transportista = Usuario.fromReference(ViajeTransportifyBD.obtenerTransportista(snapshot));

    await Future.wait([this.destino.waitForInit(), this.origen.waitForInit(), this.transportista.waitForInit()]);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[ViajeTransportifyBD.atributo_destino] = this.destino?.reference;
    map[ViajeTransportifyBD.atributo_origen] = this.origen?.reference;
    map[ViajeTransportifyBD.atributo_transportista] = this.transportista?.reference;
    map[ViajeTransportifyBD.atributo_carga_maxima] = this.cargaMaxima;
    map[ViajeTransportifyBD.atributo_fecha] = this.fecha;
    return map;
  }
}
