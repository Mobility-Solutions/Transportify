import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ComponenteBD {
  final CollectionReference coleccion;

  DocumentReference _reference;
  DocumentReference get reference => _reference;
  String get id => reference?.documentID;

  Future<void> _init;
  Future<void> waitForInit() => _init;

  ComponenteBD({String coleccion})
  : this.coleccion = coleccion == null ? null : Firestore.instance.collection(coleccion);

  ComponenteBD.fromReference(DocumentReference reference, {bool init = true}) :
    this._reference = reference,
    this.coleccion = reference?.parent() {
      if (init && reference != null) this._init = revertToBD();
      else this._init = Future.value();
    }

  ComponenteBD.fromSnapshot(DocumentSnapshot snapshot)
  : this.coleccion = snapshot.reference.parent() {
    _init = this.loadFromSnapshot(snapshot);
  }

  @override
  bool operator ==(o) => o is ComponenteBD && o?.id == id;

  @override
  int get hashCode => id.hashCode;

  Future<void> loadFromSnapshot(DocumentSnapshot snapshot) async {
    this._reference = snapshot.reference;
  }

  Future<Map<String, dynamic>> toMap();

  Future<void> crearEnBD() async {
    Map<String, dynamic> map = await this.toMap();
    if (map != null) {
      if (reference == null) {
        return coleccion.add(map).then((reference) {
          this._reference = reference;
        });
      } else {
        return reference.setData(map);
      }
    } else {
      throw UnsupportedError("No se pueden crear instancias de este objeto");
    }
  }

  Future<void> updateBD() async {
    Map<String, dynamic> map = await this.toMap();
    if (map != null) {
      return reference?.updateData(map);
    } else {
      throw UnsupportedError("Este objeto es de solo lectura");
    }
  }

  Future<void> revertToBD() => reference?.get()?.then((snapshot) {
    if (snapshot.exists) {
      return loadFromSnapshot(snapshot);
    } else {
      throw StateError("Este objeto no existe en la base de datos");
    }
  });

  Future<void> deleteFromBD() => reference?.delete();
}