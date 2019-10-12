import 'Paquete.dart';
import 'Viaje.dart';
import 'enumerados/EstadoPaquete.dart';

class Envio {
  EstadoPaquete estado;
  Paquete paquete;
  Viaje viaje;

  Envio({this.estado, this.paquete, this.viaje});

}
