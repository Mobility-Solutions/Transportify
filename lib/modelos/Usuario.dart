import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/middleware/ViajeBD.dart';

import 'Paquete.dart';
import 'Viaje.dart';

class Usuario extends ComponenteBD {
  String _uid, nombre, nickname, password, correo, ciudad;
  int edad;

  int paquetesCreados, viajesCreados;

  String get uid => _uid;

  Usuario({
    this.nombre,
    this.nickname,
    this.ciudad,
    this.edad,
    this.correo,
    this.password,
  })  : paquetesCreados = 0,
        viajesCreados = 0,
        super(coleccion: UsuarioBD.coleccion_usuarios);

  Usuario.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Usuario.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this._uid = UsuarioBD.obtenerUid(snapshot);
    this.nombre = UsuarioBD.obtenerNombre(snapshot);
    this.nickname = UsuarioBD.obtenerNickname(snapshot);
    this.ciudad = UsuarioBD.obtenerCiudad(snapshot);
    this.edad = UsuarioBD.obtenerEdad(snapshot);
    this.paquetesCreados = UsuarioBD.obtenerPaquetesCreados(snapshot);
    this.viajesCreados = UsuarioBD.obtenerViajesCreados(snapshot);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[UsuarioBD.atributo_uid] = this._uid;
    map[UsuarioBD.atributo_nombre] = this.nombre;
    map[UsuarioBD.atributo_nickname] = this.nickname;
    map[UsuarioBD.atributo_ciudad] = this.ciudad;
    map[UsuarioBD.atributo_edad] = this.edad;
    map[UsuarioBD.atributo_paquetes_creados] = this.paquetesCreados;
    map[UsuarioBD.atributo_viajes_creados] = this.viajesCreados;
    return map;
  }

  @override
  Future<void> crearEnBD() async {
    AuthResult result = await UsuarioBD.crearUsuario(
        correo: this.correo, password: this.password);

    final FirebaseUser user = result.user;
    if (user != null) {
      this._uid = user.uid;
    }

    return super.crearEnBD();
  }

  /// Además del usuario, elimina todos sus paquetes y viajes publicados
  @override
  Future<void> deleteFromBD() {
    _eliminarTodosMisViajesYPaquetesPublicados();
    return super.deleteFromBD();
  }

  Future<void> _eliminarTodosMisViajesYPaquetesPublicados() => Future.wait([
        _eliminarTodosMisViajesPublicados(),
        _eliminarTodosMisPaquetesPublicados()
      ]);

  Future<void> _eliminarTodosMisViajesPublicados() =>
      obtenerMisViajesPublicados()
          .then((listado) => Datos.eliminarTodosLosComponentes(listado));

  Future<void> _eliminarTodosMisPaquetesPublicados() =>
      obtenerMisPaquetesPublicados()
          .then((listado) => Datos.eliminarTodosLosComponentes(listado));

  Future<Iterable<Viaje>> obtenerMisViajesPublicados() =>
      ViajeBD.obtenerListadoViajes().then(
          (listado) => listado.where((viaje) => viaje.transportista == this));

  Future<Iterable<Paquete>> obtenerMisPaquetesPublicados() =>
      PaqueteBD.obtenerListadoPaquetes().then(
          (listado) => listado.where((paquete) => paquete.remitente == this));
}
