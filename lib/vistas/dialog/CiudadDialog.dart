import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';

class CiudadDialog extends StatefulWidget {
  final String ciudadInicial;

  CiudadDialog({this.ciudadInicial});

  @override
  _CiudadDialogState createState() => new _CiudadDialogState(ciudadInicial: ciudadInicial);

  static Future<String> show(BuildContext context, {String ciudadInicial}) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return CiudadDialog(ciudadInicial: ciudadInicial);
          });
}

class _CiudadDialogState extends State<CiudadDialog> {
  String _ciudadSeleccionada;

  _CiudadDialogState({String ciudadInicial}) : _ciudadSeleccionada = ciudadInicial;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Seleccione una ciudad:"),
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
