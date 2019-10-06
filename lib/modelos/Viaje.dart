import 'Usuario.dart';
import 'PuntoTransportify.dart';

class Viaje {
  DateTime fecha;
  PuntoTransportify destino;
  PuntoTransportify origen;
  Usuario transportista;

  Viaje({this.fecha, this.destino, this.origen, this.transportista});
}
