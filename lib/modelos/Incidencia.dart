import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/middleware/ComponenteBD.dart';
import 'package:transportify/middleware/IncidenciaBD.dart';

class Incidencia extends ComponenteBD {
  String descripcion;
  int retrasoHoras;

  Incidencia(
      {this.descripcion,
      this.retrasoHoras,
      }) : super(coleccion: IncidenciaBD.coleccion_incidencias);

  Incidencia.fromReference(DocumentReference reference, {bool init = true})
      : super.fromReference(reference, init: init);

  Incidencia.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);

  @override
  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    super.loadFromSnapshot(snapshot);
    this.descripcion = IncidenciaBD.obtenerDescripcion(snapshot);
    this.retrasoHoras = IncidenciaBD.obtenerRetrasoHoras(snapshot);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[IncidenciaBD.atributo_descripcion] = this.descripcion;
    map[IncidenciaBD.atributo_retrasoHoras] = this.retrasoHoras;
    return map;
  }
}
