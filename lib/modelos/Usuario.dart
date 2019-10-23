import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{
  String nombre;
  String id;

  Usuario({this.nombre});

  Usuario.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.nombre = snapshot['nombre'];
  }
}