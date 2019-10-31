import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

class PuntoTransportifyBD {
  static const String coleccion_puntos = 'puntos_transportify';

  static const String atributo_apodo = 'apodo';
  static const String atributo_direccion = 'direccion';
  static const String atributo_ciudad = 'ciudad';
  static const String atributo_localizacion = 'localizacion';

  static String obtenerApodo(DocumentSnapshot snapshot) => snapshot[atributo_apodo];
  static String obtenerDireccion(DocumentSnapshot snapshot) => snapshot[atributo_direccion];
  static String obtenerCiudad(DocumentSnapshot snapshot) => snapshot[atributo_ciudad];
  static GeoPoint obtenerLocalizacion(DocumentSnapshot snapshot) => snapshot[atributo_localizacion];

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_puntos, builder);
  }

  static Widget obtenerDropDownCiudadesYListadoPuntos(
      {Function(String) onCiudadChanged,
      String ciudadValue,
      Function(PuntoTransportify) onPuntoChanged}) {
    return obtenerStreamBuilderListado(
        _obtenerDropDownBuilder(onCiudadChanged, ciudadValue, onPuntoChanged));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerDropDownBuilder(Function(String) onCiudadChanged,
          String ciudadValue, Function(PuntoTransportify) onPuntoChanged) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerDropDownCiudadesYListadoPuntos(
          context, snapshot, onCiudadChanged, ciudadValue, onPuntoChanged);
    };
  }

  static Widget _obtenerDropDownCiudadesYListadoPuntos(
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

  static Widget _obtenerListViewItem(
      DocumentSnapshot snapshot, Function(PuntoTransportify) onSelected) {
    PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(punto);
    }

    return ListTile(
      title: Text(punto.nombre),
      onTap: onTap,
    );
  }
}