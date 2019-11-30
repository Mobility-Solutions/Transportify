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

class _RootPageState extends State<RootPage>{

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  Usuario _usuario;

  @override
  void initState(){
    super.initState();
    UsuarioBD.obtenerUsuarioActual().then((usuario){
      setState(() {
        if (usuario != null) {
          _usuario = usuario;
        }
        authStatus = usuario == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback(){
    UsuarioBD.obtenerUsuarioActual().then((usuario){
      setState((){
        _usuario = usuario;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback(){
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _usuario = null;
    });
  }

  Widget buildWaitingScreen(){
    ///TODO: Pantalla de Carga
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:
        CircularProgressIndicator(),
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
  }