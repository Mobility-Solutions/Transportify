import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';

class Usuario extends ComponenteBD {
  static const String atributo_nombre = 'nombre';

  String nombre;

  Usuario({this.nombre});

  Usuario.fromReference(DocumentReference reference)
      : super.fromReference(reference);

  Usuario.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.nombre = snapshot[atributo_nombre];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[atributo_nombre] = this.nombre;
    return map;
  }
}
