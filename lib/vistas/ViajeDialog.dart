import 'package:flutter/material.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/middleware/ViajeBD.dart';

class ViajeDialog extends StatefulWidget {
  @override
  _ViajeDialogState createState() => new _ViajeDialogState();

  static Future<ViajeDialog> show(BuildContext context) async =>
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
        title: Text("Viajes modificables: "),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: ViajeBD.obtenerListadoViajes(
                onSelected: (_viajeSeleccionado){
                  Navigator.pop(context, _viajeSeleccionado);
                }
              ),
            )));
  }
}