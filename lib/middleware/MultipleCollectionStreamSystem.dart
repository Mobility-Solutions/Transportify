import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Hay que llamar al método `dispose()` en el método `dispose()` de tu Widget o State.
class MultipleCollectionStreamSystem {
  final Map<Type, QuerySnapshot> _currentSnapshots = Map<Type, QuerySnapshot>();

  final StreamController<Map<Type, QuerySnapshot>> _snapshotsController =
      StreamController.broadcast();

  Stream<Map<Type, QuerySnapshot>> get snapshots => _snapshotsController.stream;

  final Map<Type, Stream<QuerySnapshot>> _collectionStreams =
      Map<Type, Stream<QuerySnapshot>>();

  MultipleCollectionStreamSystem([Map<Type, Stream<QuerySnapshot>> streams]) {
    streams?.forEach(add);
  }

  void add(Type type, Stream<QuerySnapshot> collectionStream) {
    int index = _collectionStreams.length;
    _collectionStreams[type] = collectionStream;
    collectionStream.listen((snapshot) => _updateSnapshot(snapshot, type, index));
  }

  void _updateSnapshot(QuerySnapshot snapshot, Type type, int index) {
    // Reemplaza el elemento de la lista por el nuevo
    _currentSnapshots[type] = snapshot;

    // Avisa del cambio
    _snapshotsController.add(_currentSnapshots);
  }

  void dispose() {
    _snapshotsController.close();
  }
}
