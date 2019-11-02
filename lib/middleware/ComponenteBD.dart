import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ComponenteBD {
  final CollectionReference coleccion;

  DocumentReference _reference;
  DocumentReference get reference => _reference;
  String get id => reference?.documentID;

  Future<void> _init;

  ComponenteBD({String coleccion})
  : this.coleccion = Firestore.instance.collection(coleccion);

  ComponenteBD.fromReference(DocumentReference reference) :
    this._reference = reference,
    this.coleccion = reference.parent() {
      this._init = revertToBD();
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

  Future<void> waitForInit() async {
    await _init;
  }

  Map<String, dynamic> toMap();

  Future<void> crearEnBD() {
    Map<String, dynamic> map = this.toMap();
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

  Future<void> updateBD() {
    Map<String, dynamic> map = this.toMap();
    if (map != null) {
      return reference?.updateData(map);
    } else {
      throw UnsupportedError("Este objeto es de solo lectura");
    }
  }

  Future<void> revertToBD() => reference?.get()?.then((snapshot) => loadFromSnapshot(snapshot));

  Future<void> deleteFromBD() => reference?.delete();
}