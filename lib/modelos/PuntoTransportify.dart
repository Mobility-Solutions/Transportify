import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PuntoTransportify {
  static const String coleccion_puntos = 'puntos_transportify';

  static const String atributo_nombre = 'nombre';
  static const String atributo_direccion = 'direccion';
  static const String atributo_ciudad = 'ciudad';
  static const String atributo_localizacion = 'localizacion';

  String id;
  String nombre;
  String direccion;
  String ciudad;
  double latitud, longitud;

  PuntoTransportify({this.nombre, this.direccion, this.ciudad, this.latitud, this.longitud});

  PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.nombre = snapshot[atributo_nombre];
    this.direccion = snapshot[atributo_direccion];
    this.ciudad = snapshot[atributo_ciudad];

    GeoPoint localizacion = snapshot[atributo_localizacion];
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
  }

  @override
  bool operator ==(o) => o is PuntoTransportify && o.id == id;

  @override
  int get hashCode => id.hashCode;

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return obtenerStreamBuilderCollectionBD(coleccion_puntos, builder);
  }

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderCollectionBD(
      String collection,
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(collection).snapshots(),
        builder: builder);
  }

  static StreamBuilder<DocumentSnapshot> obtenerStreamBuilderDocumentBD(
      String path,
      Function(BuildContext, AsyncSnapshot<DocumentSnapshot>) builder) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.document(path).snapshots(),
        builder: builder);
  }

  static Widget obtenerDropDown({Function(String) onCiudadChanged, String ciudadValue, Function(PuntoTransportify) onPuntoChanged}) {
    return obtenerStreamBuilderListado(
        _obtenerDropDownBuilder(onCiudadChanged, ciudadValue, onPuntoChanged));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerDropDownBuilder(Function(String) onCiudadChanged, String ciudadValue, Function(PuntoTransportify) onPuntoChanged) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerDropDown(context, snapshot, onCiudadChanged, ciudadValue, onPuntoChanged);
    };
  }

  static Widget _obtenerDropDown(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Function(String) onCiudadChanged,
      String ciudadSeleccionada,
      Function(PuntoTransportify) onPuntoChanged) {
    if (!snapshot.hasData) return const Text('Cargando...');

    List<DropdownMenuItem<String>> items = [];
    var ciudades =
        snapshot.data.documents.map((doc) => doc[atributo_ciudad]).toSet();

    for (String ciudad in ciudades) {
      if (ciudad != null && ciudad.length > 0) {
        items.add(
          DropdownMenuItem<String>(
            child: Text(ciudad),
            value: ciudad,
          ),
        );
      }
    }

    var puntosDeLaCiudad = _obtenerPuntosDeLaCiudad(
      puntos: snapshot.data.documents,
      ciudad: ciudadSeleccionada,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          items: items,
          onChanged: onCiudadChanged,
          value: ciudadSeleccionada,
        ),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: ListView.builder(
              itemExtent: 30.0,
              itemCount: ciudades.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < puntosDeLaCiudad.length) {
                  var punto = puntosDeLaCiudad.elementAt(index);
                  return _obtenerListViewItem(punto, onPuntoChanged);
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  static Iterable<DocumentSnapshot> _obtenerPuntosDeLaCiudad(
      {Iterable<DocumentSnapshot> puntos, String ciudad}) {
    return puntos.where((punto) => punto[atributo_ciudad] == ciudad);
  }

  // static DropdownMenuItem _obtenerDropDownMenuItem(DocumentSnapshot snapshot) {
  //   PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);
  //   return DropdownMenuItem(
  //     child: Text(punto?.nombre ?? ""),
  //     value: punto,
  //   );
  // }

  static Widget _obtenerListViewItem(DocumentSnapshot snapshot, Function(PuntoTransportify) onSelected) {
    PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);

    String texto = punto?.nombre;
    if (texto == null || texto.length == 0) {
      texto = punto?.direccion ?? "<punto-sin-nombre>";
    }

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(punto);
    }

    return ListTile(
      title: Text(texto),
      onTap: onTap,
    );
  }
}
