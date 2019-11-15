import 'Usuario.dart';

class DatosUsuarioActual {
  static DatosUsuarioActual _instance;
  
  Usuario usuario;

  DatosUsuarioActual._private();

  static DatosUsuarioActual get instance {
    if (_instance == null) {
      _instance = DatosUsuarioActual._private();
    }

    return _instance;
  }
  
}