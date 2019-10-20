import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/PaqueteTransportifyBD.dart';

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
    this.nombre = PaqueteTransportifyBD.obtenerNombre(snapshot);
    this.largo = PaqueteTransportifyBD.obtenerLargo(snapshot);
    this.ancho = PaqueteTransportifyBD.obtenerAncho(snapshot);
    this.alto = PaqueteTransportifyBD.obtenerAlto(snapshot);
    this.peso = PaqueteTransportifyBD.obtenerPeso(snapshot);
    this.fragil = PaqueteTransportifyBD.obtenerFragil(snapshot);
    this.precio = PaqueteTransportifyBD.obtenerPrecio(snapshot);
    this.fechaEntrega = PaqueteTransportifyBD.obtenerFechaEntrega(snapshot);
    this.destinoId = PaqueteTransportifyBD.obtenerIdDestino(snapshot);
    this.origenId = PaqueteTransportifyBD.obtenerIdOrigen(snapshot);
    this.remitenteId = PaqueteTransportifyBD.obtenerIdRemitente(snapshot);
  }
}


