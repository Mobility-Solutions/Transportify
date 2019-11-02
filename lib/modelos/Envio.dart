import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/EnviosBD.dart';

import 'Paquete.dart';
import 'Viaje.dart';
import 'enumerados/EstadoPaquete.dart';

class Envio extends ComponenteBD {
  EstadoPaquete estado;
  Paquete paquete;
  Viaje viaje;

  Envio({this.estado, this.paquete, this.viaje}) : super(coleccion: EnviosBD.coleccion_envios);

  Envio.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.estado = EnviosBD.obtenerEstado(snapshot);
    this.paquete = Paquete.fromReference(EnviosBD.obtenerPaquete(snapshot));
    this.viaje = Viaje.fromReference(EnviosBD.obtenerViaje(snapshot));

    await Future.wait([this.paquete.waitForInit(), this.viaje.waitForInit()]);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[EnviosBD.atributo_estado] = this.estado;
    map[EnviosBD.atributo_paquete] = this.paquete?.reference;
    map[EnviosBD.atributo_viaje] = this.viaje?.reference;
    return map;
  }
}
