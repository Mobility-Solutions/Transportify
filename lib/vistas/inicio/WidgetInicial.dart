import 'package:flutter/widgets.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/enumerados/AuthStatus.dart';
import 'package:transportify/vistas/inicio/WaitingScreen.dart';
import 'package:transportify/vistas/inicio/Authentication/iniciarSesion/iniciarSesion.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';

abstract class WidgetInicial extends Widget {
  factory WidgetInicial(
    AuthStatus authStatus, {
    Usuario usuario,
    VoidCallback loginCallback,
    VoidCallback logoutCallback,
  }) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return const WaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return IniciarSesionView(
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (usuario != null) {
          return MyHomePage(
            usuario: usuario,
            logoutCallback: logoutCallback,
          );
        } else
          return const WaitingScreen();
        break;
      default:
        return const WaitingScreen();
    }
  }
}
