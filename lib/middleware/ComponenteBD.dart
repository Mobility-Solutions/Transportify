import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ComponenteBD {
  DocumentReference reference;
  
  String get id => reference?.documentID;

  ComponenteBD({this.reference});

  ComponenteBD.fromSnapshot(DocumentSnapshot snapshot) {
    this.loadFromSnapshot(snapshot);
  }

  @override
  bool operator ==(o) => o is ComponenteBD && o?.id == id;

  @override
  int get hashCode => id.hashCode;

  void loadFromSnapshot(DocumentSnapshot snapshot) {
    this.reference = snapshot.reference;
  }

  Map<String, dynamic> toMap();

  Future<void> updateBD() {
    Map<String, dynamic> map = this.toMap();
    if (map != null) {
      return reference.updateData(map);
    } else {
      throw UnsupportedError("Este objeto es de solo lectura");
    }
  }

  Future<void> revertToBD() => reference.get().then((snapshot) => loadFromSnapshot(snapshot));

  Future<void> deleteFromBD() => reference.delete();
}