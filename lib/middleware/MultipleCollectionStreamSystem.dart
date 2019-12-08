import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Hay que llamar al método `dispose()` en el método `dispose()` de tu Widget o State.
class MultipleCollectionStreamSystem {
  final List<QuerySnapshot> _currentSnapshots = List<QuerySnapshot>();

  final StreamController<List<QuerySnapshot>> _snapshotsController =
      StreamController.broadcast();

  Stream<List<QuerySnapshot>> get snapshots => _snapshotsController.stream;

  final List<Stream<QuerySnapshot>> _collectionStreams =
      List<Stream<QuerySnapshot>>();

  MultipleCollectionStreamSystem([Iterable<Stream<QuerySnapshot>> streams]) {
    if (streams != null) {
      for (var stream in streams) {
        add(stream);
      }
    }
  }

  void add(Stream<QuerySnapshot> collectionStream) {
    int index = _collectionStreams.length;
    _collectionStreams.add(collectionStream);
    collectionStream.listen((snapshot) => _updateSnapshot(snapshot, index));
  }

  void _updateSnapshot(QuerySnapshot snapshot, int index) {
    // Reemplaza el elemento de la lista por el nuevo
    _currentSnapshots.replaceRange(index, index + 1, [snapshot]);

    // Avisa del cambio
    _snapshotsController.add(_currentSnapshots);
  }

  void dispose() {
    _snapshotsController.close();
  }
}
