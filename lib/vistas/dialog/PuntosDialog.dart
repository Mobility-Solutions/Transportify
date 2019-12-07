import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

class PuntosDialog extends StatefulWidget {
  final String ciudadInicial;
  final PuntoTransportify puntoInicial;

  PuntosDialog({this.ciudadInicial, this.puntoInicial});

  @override
  _PuntosDialogState createState() => puntoInicial == null
      ? _PuntosDialogState(ciudadInicial: ciudadInicial)
      : _PuntosDialogState.from(puntoInicial: puntoInicial);

  static Future<PuntoTransportify> show(BuildContext context,
          {String ciudadInicial, PuntoTransportify puntoInicial}) async =>
      await showDialog(
          context: context,
          builder: (_) {
            return PuntosDialog(
                ciudadInicial: ciudadInicial, puntoInicial: puntoInicial);
          });
}

class _PuntosDialogState extends State<PuntosDialog> {
  String _ciudadSeleccionada;
  PuntoTransportify _puntoSeleccionado;

  _PuntosDialogState({String ciudadInicial})
      : _ciudadSeleccionada = ciudadInicial;

  _PuntosDialogState.from({PuntoTransportify puntoInicial})
      : _ciudadSeleccionada = puntoInicial.ciudad,
        _puntoSeleccionado = puntoInicial;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(_ciudadSeleccionada == null
            ? "Seleccione una ciudad:"
            : "Seleccione un Punto Transportify:"),
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
