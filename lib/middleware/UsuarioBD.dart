import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/modelos/Usuario.dart';

import 'Datos.dart';

class UsuarioBD {
  static const String coleccion_usuarios = 'usuarios';
  static const String atributo_uid = 'uid';
  static const String atributo_nombre = 'nombre';
  static const String atributo_nickname = 'nickname';
  static const String atributo_ciudad = 'ciudad';
  static const String atributo_edad = 'edad';
  static const String atributo_paquetes_creados = 'paquetes_creados';
  static const String atributo_viajes_creados = 'viajes_creados';

  static String obtenerUid(DocumentSnapshot snapshot) => snapshot[atributo_uid];
  static String obtenerNombre(DocumentSnapshot snapshot) =>
      snapshot[atributo_nombre];
  static String obtenerNickname(DocumentSnapshot snapshot) =>
      snapshot[atributo_nickname];
  static String obtenerCiudad(DocumentSnapshot snapshot) =>
      snapshot[atributo_ciudad];
  static int obtenerEdad(DocumentSnapshot snapshot) => snapshot[atributo_edad];
  static int obtenerPaquetesCreados(DocumentSnapshot snapshot) =>
      snapshot[atributo_paquetes_creados];
  static int obtenerViajesCreados(DocumentSnapshot snapshot) =>
      snapshot[atributo_viajes_creados];

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_usuarios, builder);
  }

  static Widget obtenerListadoUsuarios({Function(Usuario) onSelected}) {
    return obtenerStreamBuilderListado(
        _obtenerListadoUsuariosBuilder(onSelected));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerListadoUsuariosBuilder(Function(Usuario) onSelected) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerListadoUsuarios(context, snapshot, onSelected);
    };
  }

  static Widget _obtenerListadoUsuarios(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, Function(Usuario) onSelected) {
    if (!snapshot.hasData) return const Center(child: const CircularProgressIndicator());

    var usuarios = snapshot.data.documents;

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index >= 0 && index < usuarios.length) {
          var usuario = usuarios.elementAt(index);
          return _obtenerListViewItemUsuario(usuario, onSelected);
        } else {
          return null;
        }
      },
    );
  }

  static Widget _obtenerListViewItemUsuario(
      DocumentSnapshot snapshot, Function(Usuario) onSelected) {
    Usuario usuario = Usuario.fromSnapshot(snapshot);

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(usuario);
    }

    return ListTile(
      title: Text(usuario.nombre + " (${usuario.nickname})"),
      onTap: onTap,
    );
  }

  static Future<AuthResult> crearUsuario({String correo, String password}) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: correo, password: password);
  }

  static Future<Usuario> obtenerUsuarioActual() => FirebaseAuth.instance
      .currentUser()
      .then((firebaseUser) => 
      firebaseUser == null ? null : obtenerUsuarioConUid(firebaseUser.uid));

  static Future<Usuario> obtenerUsuarioConUid(String uid) {
    return Datos.obtenerColeccion(coleccion_usuarios)
        .getDocuments()
        .then((query) {
      var listadoUsuarios = query.documents;
      DocumentSnapshot usuarioSnapshot =
          listadoUsuarios.firstWhere((snapshot) => obtenerUid(snapshot) == uid);
      return Usuario.fromSnapshot(usuarioSnapshot);
    });
  }

  static Future<AuthResult> loginConCorreoYPassword(
      {String correo, String password}) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: correo,
      password: password,
    );
  }

  static Future<AuthResult> loginConCredenciales(AuthCredential credential) =>
      FirebaseAuth.instance.signInWithCredential(credential);

  static Future<void> signOut() => FirebaseAuth.instance.signOut();
}
