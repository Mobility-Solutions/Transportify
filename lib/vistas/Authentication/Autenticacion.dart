import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';

class Autenticacion{

  static Future<void> checkUserIsLogged(BuildContext context) async {
    final Usuario usuarioLoggeado = await UsuarioBD.obtenerUsuarioActual();
    if (usuarioLoggeado!=null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(usuario:usuarioLoggeado)),
      );
    }
  }

  static void userSignInCorrectly(BuildContext context, Usuario usuario) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(usuario: usuario)),
    );
  }

  static void userSignInIncorrectly(){

  }
}