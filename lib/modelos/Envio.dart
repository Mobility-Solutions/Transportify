import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';

class Envio{
  String id;
 EstadoPaquete estado;
 String id_paquete;
 String id_viaje;

  Envio(this.id, this.estado, this.id_paquete, this.id_viaje);


}