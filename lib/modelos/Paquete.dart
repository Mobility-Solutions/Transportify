import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/PaqueteBD.dart';

import 'PuntoTransportify.dart';
import 'Usuario.dart';
import 'Viaje.dart';
import 'enumerados/EstadoPaquete.dart';


class Paquete extends ComponenteBD {
  String nombre;
  double largo, ancho, alto;
  double peso;
  bool fragil;
  PuntoTransportify destino;
  PuntoTransportify origen;
  Usuario remitente;
  double precio;
  DateTime fechaEntrega;
  EstadoPaquete estado;
  Viaje viajeAsignado;

  Paquete(
      {this.nombre,
      this.alto,
      this.ancho,
      this.largo,
      this.peso,
      this.fragil,
      this.destino,
      this.origen,
      this.remitente,
      this.precio,
      this.fechaEntrega,
      this.estado,
      this.viajeAsignado})
      : super(coleccion: PaqueteBD.coleccion_paquetes);

  Paquete.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Paquete.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.nombre = PaqueteBD.obtenerNombre(snapshot);
    this.largo = PaqueteBD.obtenerLargo(snapshot);
    this.ancho = PaqueteBD.obtenerAncho(snapshot);
    this.alto = PaqueteBD.obtenerAlto(snapshot);
    this.peso = PaqueteBD.obtenerPeso(snapshot);
    this.fragil = PaqueteBD.obtenerFragil(snapshot);
    this.precio = PaqueteBD.obtenerPrecio(snapshot);
    this.fechaEntrega = PaqueteBD.obtenerFechaEntrega(snapshot).toDate();
    this.destino =
        PuntoTransportify.fromReference(PaqueteBD.obtenerDestino(snapshot));
    this.origen =
        PuntoTransportify.fromReference(PaqueteBD.obtenerOrigen(snapshot));
    this.remitente =
        Usuario.fromReference(PaqueteBD.obtenerRemitente(snapshot));
    this.estado = 
        PaqueteBD.obtenerEstado(snapshot);
    this.viajeAsignado =Viaje.fromReference(PaqueteBD.obtenerViaje(snapshot));

    await Future.wait([
      this.destino.waitForInit(),
      this.origen.waitForInit(),
      this.remitente.waitForInit(),
      this.viajeAsignado.waitForInit()
    ]);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[PaqueteBD.atributo_nombre] = this.nombre;
    map[PaqueteBD.atributo_alto] = this.alto;
    map[PaqueteBD.atributo_ancho] = this.ancho;
    map[PaqueteBD.atributo_fragil] = this.fragil;
    map[PaqueteBD.atributo_destino] = this.destino?.reference;
    map[PaqueteBD.atributo_origen] = this.origen?.reference;
    map[PaqueteBD.atributo_remitente] = this.remitente?.reference;
    map[PaqueteBD.atributo_largo] = this.largo;
    map[PaqueteBD.atributo_peso] = this.peso;
    map[PaqueteBD.atributo_precio] = this.precio;
    map[PaqueteBD.atributo_fecha_entrega] = this.fechaEntrega;
    map[PaqueteBD.atributo_estado] = this.estado;
    map[PaqueteBD.atributo_viaje_asignado] = this.viajeAsignado?.reference;
    return map;
  }
}
