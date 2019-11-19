import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

class PuntosDialog extends StatefulWidget {
  @override
  _PuntosDialogState createState() => new _PuntosDialogState();

  static Future<PuntoTransportify> show(BuildContext context) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return PuntosDialog();
          });
}

class _PuntosDialogState extends State<PuntosDialog> {
  String _ciudadSeleccionada;
  PuntoTransportify _puntoSeleccionado;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(_ciudadSeleccionada == null ? "Seleccione una ciudad:" : "Seleccione un Punto Transportify:"),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: PuntoTransportifyBD.obtenerSelectorCiudadesYPuntos(
                onPuntoChanged: (nuevoPunto) {
                  setState(() {
                    this._puntoSeleccionado = nuevoPunto;
                  });
                },
                onCiudadChanged: (nuevaCiudad) {
                  setState(() {
                    this._ciudadSeleccionada = nuevaCiudad;
                  });
                },
                onSelected: (nuevoPunto) => Navigator.pop(context, nuevoPunto),
                onCanceled: () => Navigator.pop(context, null),
                ciudadValue: _ciudadSeleccionada,
                puntoValue: _puntoSeleccionado,
              ),
            )));
  }
}
