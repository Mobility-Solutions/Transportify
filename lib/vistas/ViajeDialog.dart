import 'package:flutter/material.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/middleware/ViajeBD.dart';

import 'creacion/CreacionViajeForm.dart';

class ViajeDialog extends StatefulWidget {
  @override
  _ViajeDialogState createState() => new _ViajeDialogState();

  static Future<Viaje> show(BuildContext context) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return ViajeDialog();
          });
}

class _ViajeDialogState extends State<ViajeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        key: Key('pestaña_viaje'),
        title: Text("Viajes modificables: "),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: ViajeBD.obtenerListadoViajesWidget(
                onSelected: (_viajeSeleccionado){
                  Navigator.pop(context, _viajeSeleccionado);
                }
              ),

 
            )),
        actions: <Widget>[
          new FlatButton(
            key: Key('añadir_viaje'),
            child: new Text("Crear Viaje"),
            onPressed: () {
            Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new CreacionViajeForm();
              }));
          },
          )
        ],
            );
  }
}