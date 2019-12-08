import 'package:flutter/material.dart';
import 'package:transportify/middleware/ActividadBD.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/modelos/enumerados/EstadoActividad.dart';
import '../../middleware/MultipleCollectionStreamSystem.dart';

class MiActividadBusqueda extends StatefulWidget {
  final EstadoActividad estado;
  final Usuario usuario;

  @override
  _MiActividadBusquedaState createState() => _MiActividadBusquedaState();

  MiActividadBusqueda(this.estado, this.usuario);
}

class _MiActividadBusquedaState extends State<MiActividadBusqueda> {
  bool _loading;
  List resultados = new List();
  MultipleCollectionStreamSystem multipleCollection;
  Map colecciones;

  getActividades() async {
    setState(() {
      _loading = true;
    });

    switch (widget.estado) {
      case EstadoActividad.PUBLICADO:
        colecciones[Paquete] = PaqueteBD.coleccion_paquetes;
        colecciones[Viaje] = ViajeBD.coleccion_viajes;
        multipleCollection = Datos.obtenerStreamsCollectionsBD(colecciones);
        break;
      case EstadoActividad.ENCURSO:
        break;
      case EstadoActividad.FINALIZADO:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getActividades();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ?Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)),)
    : Column(
            children: <Widget>[
              ActividadBD.obtenerListaActividadesCards(multipleCollectionStreamSystem: multipleCollection,usuario: widget.usuario)
            ],
          );
  }
  
}
