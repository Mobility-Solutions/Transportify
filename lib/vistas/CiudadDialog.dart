import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

class CiudadDialog extends StatefulWidget {
  @override
  _CiudadDialogState createState() => new _CiudadDialogState();

  static Future<String> show(BuildContext context) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return CiudadDialog();
          });
}

class _CiudadDialogState extends State<CiudadDialog> {
  String _ciudadSeleccionada;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Selecciona una ciudad"),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: PuntoTransportifyBD.obtenerSelectorCiudades(
                onSelectionChanged: (nuevaCiudad) {
                  setState(() {
                    _ciudadSeleccionada = nuevaCiudad;
                  });
                },
                onSelected: (nuevaCiudad) => Navigator.pop(context, nuevaCiudad),
                onCanceled: () => Navigator.pop(context, null),
                ciudadValue: _ciudadSeleccionada,
              ),
            )));
  }
}
