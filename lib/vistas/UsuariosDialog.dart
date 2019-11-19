import 'package:flutter/material.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/modelos/Usuario.dart';

class UsuariosDialog extends StatefulWidget {
  @override
  _PuntosDialogState createState() => new _PuntosDialogState();

  static Future<Usuario> show(BuildContext context) async => await showDialog(
      context: context,
      builder: (_) {
        return UsuariosDialog();
      });
}

class _PuntosDialogState extends State<UsuariosDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Usuarios:"),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: UsuarioBD.obtenerListadoUsuarios(
                onSelected: (usuarioSeleccionado) {
                  Navigator.pop(context, usuarioSeleccionado);
                },
              ),
            )));
  }
}
