import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/PaqueteTransportifyBD.dart';

import 'PuntoTransportify.dart';
import 'Usuario.dart';

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
      this.fechaEntrega});

  Paquete.fromReference(DocumentReference reference)
      : super.fromReference(reference);

  Paquete.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.nombre = PaqueteTransportifyBD.obtenerNombre(snapshot);
    this.largo = PaqueteTransportifyBD.obtenerLargo(snapshot);
    this.ancho = PaqueteTransportifyBD.obtenerAncho(snapshot);
    this.alto = PaqueteTransportifyBD.obtenerAlto(snapshot);
    this.peso = PaqueteTransportifyBD.obtenerPeso(snapshot);
    this.fragil = PaqueteTransportifyBD.obtenerFragil(snapshot);
    this.precio = PaqueteTransportifyBD.obtenerPrecio(snapshot);
    this.fechaEntrega = PaqueteTransportifyBD.obtenerFechaEntrega(snapshot).toDate();
    this.destino = PuntoTransportify.fromReference(PaqueteTransportifyBD.obtenerDestino(snapshot));
    this.origen = PuntoTransportify.fromReference(PaqueteTransportifyBD.obtenerOrigen(snapshot));
    this.remitente = Usuario.fromReference(PaqueteTransportifyBD.obtenerRemitente(snapshot));
    
    await Future.wait([this.destino.waitForInit(), this.origen.waitForInit(), this.remitente.waitForInit()]);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[PaqueteTransportifyBD.atributo_nombre] = this.nombre;
    map[PaqueteTransportifyBD.atributo_alto] = this.alto;
    map[PaqueteTransportifyBD.atributo_ancho] = this.ancho;
    map[PaqueteTransportifyBD.atributo_fragil] = this.fragil;
    map[PaqueteTransportifyBD.atributo_destino] = this.destino;
    map[PaqueteTransportifyBD.atributo_origen] = this.origen;
    map[PaqueteTransportifyBD.atributo_remitente] = this.remitente;
    map[PaqueteTransportifyBD.atributo_largo] = this.largo;
    map[PaqueteTransportifyBD.atributo_peso] = this.peso;
    map[PaqueteTransportifyBD.atributo_precio] = this.precio;
    map[PaqueteTransportifyBD.atributo_fecha_entrega] = this.fechaEntrega;
    return map;
  }
}
