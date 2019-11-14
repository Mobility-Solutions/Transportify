import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/UsuarioBD.dart';

class Usuario extends ComponenteBD {
  String nombre, nickname, password, correo, ciudad;
  int edad;

  Usuario({this.nombre, 
          this.nickname, 
          this.password, 
          this.correo, 
          this.ciudad, 
          this.edad}) : super(coleccion: UsuarioBD.coleccion_usuarios);

  Usuario.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Usuario.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.nombre = UsuarioBD.obtenerNombre(snapshot);
    this.nickname = UsuarioBD.obtenerNickname(snapshot);
    this.password = UsuarioBD.obtenerPassword(snapshot);
    this.correo = UsuarioBD.obtenerCorreo(snapshot);
    this.ciudad = UsuarioBD.obtenerCiudad(snapshot);
    this.edad = UsuarioBD.obtenerEdad(snapshot);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[UsuarioBD.atributo_nombre] = this.nombre;
    map[UsuarioBD.atributo_nickname] = this.nickname;
    map[UsuarioBD.atributo_password] = this.password;
    map[UsuarioBD.atributo_correo] = this.correo;
    map[UsuarioBD.atributo_ciudad] = this.ciudad;
    map[UsuarioBD.atributo_edad] = this.edad;
    return map;
  }
}
