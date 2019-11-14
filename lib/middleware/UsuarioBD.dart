import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/modelos/Usuario.dart';

import 'Datos.dart';

class UsuarioBD {
  static const String coleccion_usuarios = 'usuarios';
  static const String atributo_nombre = 'nombre';
  static const String atributo_nickname = 'nickname';
  static const String atributo_password = 'password';
  static const String atributo_correo = 'correo';
  static const String atributo_ciudad = 'ciudad';
  static const String atributo_edad = 'edad';

  static String obtenerNombre(DocumentSnapshot snapshot) =>
      snapshot[atributo_nombre];
  static String obtenerNickname(DocumentSnapshot snapshot) =>
      snapshot[atributo_nickname];
  static String obtenerPassword(DocumentSnapshot snapshot) =>
      snapshot[atributo_password];
  static String obtenerCorreo(DocumentSnapshot snapshot) =>
      snapshot[atributo_correo];
  static String obtenerCiudad(DocumentSnapshot snapshot) =>
      snapshot[atributo_ciudad];
  static int obtenerEdad(DocumentSnapshot snapshot) => snapshot[atributo_edad];

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
    if (!snapshot.hasData) return const Text('Cargando...');

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
}
