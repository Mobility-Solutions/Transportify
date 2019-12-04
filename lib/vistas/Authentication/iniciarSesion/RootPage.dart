import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/enumerados/AuthStatus.dart';
import 'package:transportify/vistas/Authentication/iniciarSesion/iniciarSesion.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  Usuario _usuario;

  final StreamController<Usuario> _usuarioController;
  final StreamController<AuthStatus> _authStatusController;
  Stream<Usuario> get usuarioStream => _usuarioController.stream;
  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;

  _RootPageState()
      : _usuarioController = StreamController.broadcast(),
        _authStatusController = StreamController.broadcast() {
    usuarioStream.listen((newUsuario) {
      setState(() {
        _usuario = newUsuario;
      });
    });

    authStatusStream.listen((newAuthStatus) {
      setState(() {
        authStatus = newAuthStatus;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    UsuarioBD.obtenerUsuarioActual().then((usuario) {
      setState(() {
        if (usuario != null) {
          _usuario = usuario;
        }
        authStatus =
            usuario == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() async {
    await UsuarioBD.obtenerUsuarioActual().then((usuario) {
      setState(() {
        _usuarioController.add(usuario);
        _authStatusController.add(AuthStatus.LOGGED_IN);
      });
    });
  }

  void logoutCallback() {
    setState(() {
      _authStatusController.add(AuthStatus.NOT_LOGGED_IN);
      _usuarioController.add(null);
    });
  }

  Widget buildWaitingScreen() {
    ///TODO: Pantalla de carga (splash)
    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new IniciarSesionView(
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_usuario != null) {
          return new MyHomePage(
            usuario: _usuario,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }

  @override
  void dispose() {
    _usuarioController.close();
    _authStatusController.close();
    super.dispose();
  }
}
