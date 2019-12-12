import 'package:flutter/material.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/vistas/creacion/CreacionViajeForm.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';


class ViajeDialog extends UserDependantStatelessWidget {
  ViajeDialog({Usuario usuario}) : super(usuario);

  static Future<Viaje> show(BuildContext context, {Usuario usuario}) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return ViajeDialog(usuario: usuario);
          });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
        title: Text("Viajes modificables: "),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: ViajeBD.obtenerListadoViajesWidget(
                usuario: usuario,
                onSelected: (_viajeSeleccionado){
                  Navigator.pop(context, _viajeSeleccionado);
                }
              ),

 
            )),
        actions: <Widget>[
          FlatButton(
            child: Text("Crear Viaje"),
            onPressed: () {
            Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return CreacionViajeForm(usuario: usuario);
              }));
          },
          )
        ],
            );
  }
}