import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/ViajeBD.dart';

import 'Usuario.dart';

class Viaje extends ComponenteBD {
  double cargaMaxima;
  DateTime fecha;
  String destino;
  String origen;
  bool cancelado = false;
  Usuario transportista;

  Viaje(
      {this.cargaMaxima,
      this.fecha,
      this.destino,
      this.origen,
      this.cancelado = false,
      this.transportista}) : super(coleccion: ViajeBD.coleccion_viajes);

  Viaje.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Viaje.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.cargaMaxima = ViajeBD.obtenerCargaMaxima(snapshot);
    this.fecha = ViajeBD.obtenerFecha(snapshot).toDate();
    this.destino = ViajeBD.obtenerDestino(snapshot);
    this.origen = ViajeBD.obtenerOrigen(snapshot);
    this.cancelado = ViajeBD.obtenerCancelado(snapshot);
    this.transportista = Usuario.fromReference(ViajeBD.obtenerTransportista(snapshot));

    await this.transportista.waitForInit();
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[ViajeBD.atributo_destino] = this.destino;
    map[ViajeBD.atributo_origen] = this.origen;
    map[ViajeBD.atributo_transportista] = this.transportista?.reference;
    map[ViajeBD.atributo_carga_maxima] = this.cargaMaxima;
    map[ViajeBD.atributo_cancelado] = this.cancelado;
    map[ViajeBD.atributo_fecha] = this.fecha;
    return map;
  }
}
