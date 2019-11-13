import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/util/style.dart';

class PuntoTransportifyBD {
  static const String coleccion_puntos = 'puntos_transportify';

  static const String atributo_apodo = 'apodo';
  static const String atributo_direccion = 'direccion';
  static const String atributo_ciudad = 'ciudad';
  static const String atributo_localizacion = 'localizacion';

  static String obtenerApodo(DocumentSnapshot snapshot) =>
      snapshot[atributo_apodo];
  static String obtenerDireccion(DocumentSnapshot snapshot) =>
      snapshot[atributo_direccion];
  static String obtenerCiudad(DocumentSnapshot snapshot) =>
      snapshot[atributo_ciudad];
  static GeoPoint obtenerLocalizacion(DocumentSnapshot snapshot) =>
      snapshot[atributo_localizacion];

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_puntos, builder);
  }

  static Widget obtenerSelectorCiudades(
      {Function(String) onSelectionChanged,
      Function(String) onSelected,
      Function onCanceled,
      String ciudadValue}) {
    return obtenerStreamBuilderListado(_obtenerSelectorCiudadesBuilder(
        onSelectionChanged, onSelected, onCanceled, ciudadValue));
  }

  static Widget obtenerDropDownCiudadesYListadoPuntos(
      {Function(String) onCiudadChanged,
      String ciudadValue,
      Function(PuntoTransportify) onPuntoChanged}) {
    return obtenerStreamBuilderListado(
        _obtenerDropDownCiudadesYListadoPuntosBuilder(
            onCiudadChanged, ciudadValue, onPuntoChanged));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerSelectorCiudadesBuilder(
          Function(String) onSelectionChanged,
          Function(String) onSelected,
          Function onCanceled,
          String ciudadValue) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerSelectorCiudades(context, snapshot, onSelectionChanged,
          onSelected, onCanceled, ciudadValue);
    };
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerDropDownCiudadesYListadoPuntosBuilder(
          Function(String) onCiudadChanged,
          String ciudadValue,
          Function(PuntoTransportify) onPuntoChanged) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerDropDownCiudadesYListadoPuntos(
          context, snapshot, onCiudadChanged, ciudadValue, onPuntoChanged);
    };
  }

  static Widget _obtenerSelectorCiudades(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Function(String) onSelectionChanged,
      Function(String) onSelected,
      Function onCanceled,
      String ciudadSeleccionada) {
    if (!snapshot.hasData) return const Text('Cargando...');

    var ciudades =
        snapshot.data.documents.map((doc) => doc[atributo_ciudad]).toSet();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox.expand(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index >= 0 && index < ciudades.length) {
                    String ciudad = ciudades.elementAt(index);
                    return _obtenerListViewItemCiudad(ciudad,
                        ciudad == ciudadSeleccionada, onSelectionChanged);
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Stack(
        overflow: Overflow.visible,
        alignment: new FractionalOffset(5, 0.5),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.map, color: TransportifyColors.primarySwatch[900]),
                onPressed: () {}, // TODO: onPressed del boton del mapa
              ),
              Expanded(
                child: TransportifyFormButton(
                  text: "CANCELAR",
                  onPressed: () => onCanceled(),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TransportifyFormButton(
                  text: "OK",
                  onPressed: () => onSelected(ciudadSeleccionada),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          child: SizedBox.expand(
            child: ListView.builder(
              itemExtent: 30.0,
              itemCount: ciudades.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < puntosDeLaCiudad.length) {
                  var punto = puntosDeLaCiudad.elementAt(index);
                  return _obtenerListViewItemPunto(punto, onPuntoChanged);
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

  static Widget _obtenerListViewItemCiudad(String ciudad,
          [bool seleccionada = false, Function(String) onSelected]) =>
      _obtenerListViewItem(
          item: ciudad,
          displayName: ciudad,
          selected: seleccionada,
          onSelected: onSelected);

  static Widget _obtenerListViewItemPunto(
      DocumentSnapshot snapshot, Function(PuntoTransportify) onSelected) {
    PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);
    return _obtenerListViewItem(
      item: punto,
      displayName: punto.nombre,
      onSelected: onSelected,
    );
  }

  static Widget _obtenerListViewItem<T>(
      {T item,
      String displayName,
      bool selected = false,
      Function(T) onSelected}) {
    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(item);
    }

    return Container(
      color: selected ? TransportifyColors.primarySwatch : null,
      child: ListTile(
        title: Text(
          displayName,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
