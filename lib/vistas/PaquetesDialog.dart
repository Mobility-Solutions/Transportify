import 'package:flutter/material.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/vistas/creacion/CreacionPaqueteForm.dart';

import 'creacion/CreacionViajeForm.dart';

class PaquetesDialog extends StatefulWidget {
  @override
  _PaquetesDialogState createState() => new _PaquetesDialogState();

  static Future<Paquete> show(BuildContext context) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return PaquetesDialog();
          });
}

class _PaquetesDialogState extends State<PaquetesDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
        title: Text("Paquetes modificables: "),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: PaqueteBD.obtenerPaquetesList(
                onSelected: (_paqueteSeleccionado){
                  Navigator.pop(context, _paqueteSeleccionado);
                }
              ),

 
            )),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Crear Paquete"),
            onPressed: () {
            Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new CreacionPaqueteForm();
              }));
          },
          )
        ],
            );
  }
}