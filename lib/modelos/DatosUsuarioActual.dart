import 'dart:async';

import 'Usuario.dart';

class DatosUsuarioActual {
  static DatosUsuarioActual _instance;
  
  Usuario _usuario;
  Usuario get usuario => _usuario;
  set usuario(Usuario nuevoUsuario) {
    _usuario = nuevoUsuario;
    usuarioController.add(nuevoUsuario);
  }
  
  StreamController usuarioController = StreamController.broadcast();
  Stream get usuarioStream => usuarioController.stream;

  DatosUsuarioActual._private();

  static DatosUsuarioActual get instance {
    if (_instance == null) {
      _instance = DatosUsuarioActual._private();
    }

    return _instance;
  }
  
}