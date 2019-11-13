import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';

class Usuario extends ComponenteBD {
  static const String coleccion_usuarios = 'usuarios';
  static const String atributo_nombre = 'nombre';
  static const String atributo_nickname = 'nickname';
  static const String atributo_password = 'password';
  static const String atributo_correo = 'correo';
  static const String atributo_ciudad = 'ciudad';
  static const String atributo_edad = 'edad';

  String nombre, nickname, password, correo, ciudad;
  int edad;

  Usuario({this.nombre, 
          this.nickname, 
          this.password, 
          this.correo, 
          this.ciudad, 
          this.edad}) : super(coleccion: coleccion_usuarios);

  Usuario.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Usuario.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.nombre = snapshot[atributo_nombre];
    this.nickname = snapshot[atributo_nickname];
    this.password = snapshot[atributo_password];
    this.correo = snapshot[atributo_correo];
    this.ciudad = snapshot[atributo_ciudad];
    this.edad = snapshot[atributo_edad];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[atributo_nombre] = this.nombre;
    map[atributo_nickname] = this.nickname;
    map[atributo_password] = this.password;
    map[atributo_correo] = this.correo;
    map[atributo_ciudad] = this.ciudad;
    map[atributo_edad] = this.edad;
    return map;
  }
}
