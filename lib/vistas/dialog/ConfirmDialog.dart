import 'package:flutter/material.dart';

enum ConfirmAction { ACCEPT, CANCEL }

class ConfirmDialog extends StatelessWidget {
  final String titulo;

  ConfirmDialog({this.titulo});

  static Future<ConfirmAction> show(BuildContext context, {String titulo}) async =>
      await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (_) {
            return ConfirmDialog(titulo: titulo);
          });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(ConfirmAction.CANCEL);
          },
        ),
        FlatButton(
          child: const Text('Aceptar'),
          onPressed: () {
            Navigator.of(context).pop(ConfirmAction.ACCEPT);
          },
        )
      ],
    );
  }
}
