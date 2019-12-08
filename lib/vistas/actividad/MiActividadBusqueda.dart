import 'package:flutter/material.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/modelos/enumerados/EstadoActividad.dart';

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
  Iterable<Paquete> paquetes;
  Iterable<Viaje> viajes;

  getActividades() async {
    setState(() {
      _loading = true;
    });

    switch (widget.estado) {
      case EstadoActividad.PUBLICADO:
        //!TODO llamada middleware de colecciones compartidas.
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
              //!TODO llamada obtener lista de cards.
            ],
          );
  }

  
}
