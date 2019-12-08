import 'package:flutter/material.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/vistas/creacion/CreacionPaqueteForm.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';

class PaquetesDialog extends UserDependantStatelessWidget {
  PaquetesDialog({Usuario usuario}) : super(usuario);

  static Future<Paquete> show(BuildContext context, {Usuario usuario}) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return PaquetesDialog(usuario: usuario);
          });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Paquetes modificables: "),
      content: Container(
          height: 300,
          width: 300,
          child: Center(
            child: PaqueteBD.obtenerListadoPaquetesWidget(
                usuario: usuario,
                onSelected: (_paqueteSeleccionado) {
              Navigator.pop(context, _paqueteSeleccionado);
            }),
          )),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Crear Paquete"),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return CreacionPaqueteForm(usuario: usuario);
            }));
          },
        )
      ],
    );
  }
}
