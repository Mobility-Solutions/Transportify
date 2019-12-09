import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/MapaView.dart';

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

  static Widget obtenerSelectorCiudadesYPuntos(
      {Function(String) onCiudadChanged,
      String ciudadValue,
      PuntoTransportify puntoValue,
      Function(PuntoTransportify) onPuntoChanged,
      Function(PuntoTransportify) onSelected,
      Function onCanceled}) {
    return obtenerStreamBuilderListado(_obtenerSelectorCiudadesYPuntosBuilder(
        onCiudadChanged,
        ciudadValue,
        puntoValue,
        onPuntoChanged,
        onSelected,
        onCanceled));
  }

  @deprecated
  static Future<Iterable<PuntoTransportify>> obtenerPuntos(
      [bool filtro(PuntoTransportify punto)]) {
    return Datos.obtenerColeccion(coleccion_puntos)
        .getDocuments()
        .then((query) {
      var puntos = query.documents
          .map((snapshot) => PuntoTransportify.fromSnapshot(snapshot));
      if (filtro != null) puntos = puntos.where(filtro);
      return puntos;
    });
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
      _obtenerSelectorCiudadesYPuntosBuilder(
          Function(String) onCiudadChanged,
          String ciudadValue,
          PuntoTransportify puntoValue,
          Function(PuntoTransportify) onPuntoChanged,
          Function(PuntoTransportify) onSelected,
          onCanceled) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerSelectorCiudadesYPuntos(context, snapshot, onCiudadChanged,
          ciudadValue, puntoValue, onPuntoChanged, onSelected, onCanceled);
    };
  }

  static Widget _obtenerSelectorCiudadesYPuntos(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Function(String) onCiudadChanged,
      String ciudadSeleccionada,
      PuntoTransportify puntoSeleccionado,
      Function(PuntoTransportify) onPuntoChanged,
      Function(PuntoTransportify) onSelected,
      Function onCanceled) {
    return snapshot.hasData
        ? _obtenerSelector(
            context: context,
            antesDelListado: ciudadSeleccionada == null
                ? const SizedBox()
                : Row(
                    children: <Widget>[
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10.0,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              onPuntoChanged(null);
                              onCiudadChanged(null);
                            },
                          ),
                          Text(
                            ciudadSeleccionada,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
            listado: ciudadSeleccionada == null
                ? _obtenerListadoCiudades(
                    snapshot, ciudadSeleccionada, onCiudadChanged)
                : _obtenerListadoPuntosWidget(snapshot, ciudadSeleccionada,
                    puntoSeleccionado, onPuntoChanged),
            mapaView: MapaViewPuntos(
              puntoInicial: puntoSeleccionado,
            ),
            onSelected: onSelected,
            onSelectionChanged: onPuntoChanged,
            onCanceled: onCanceled,
            itemSeleccionado: puntoSeleccionado)
        : const Center(child: const CircularProgressIndicator());
  }

  static Widget _obtenerSelectorCiudades(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Function(String) onSelectionChanged,
      Function(String) onSelected,
      Function onCanceled,
      String ciudadSeleccionada) {
    return snapshot.hasData
        ? _obtenerSelector(
            context: context,
            listado: _obtenerListadoCiudades(
                snapshot, ciudadSeleccionada, onSelectionChanged),
            mapaView: MapaViewCiudades(ciudadInicial: ciudadSeleccionada),
            onSelected: onSelected,
            onSelectionChanged: onSelectionChanged,
            onCanceled: onCanceled,
            itemSeleccionado: ciudadSeleccionada)
        : const Center(child: const CircularProgressIndicator());
  }

  static Widget _obtenerSelector<T>(
      {BuildContext context,
      Widget antesDelListado = const SizedBox(),
      Widget listado,
      Widget despuesDelListado = const SizedBox(),
      MapaView mapaView,
      Function(T) onSelected,
      Function(T) onSelectionChanged,
      Function onCanceled,
      T itemSeleccionado}) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          antesDelListado,
          Expanded(
            child: SizedBox.expand(
              child: listado,
            ),
          ),
          despuesDelListado,
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
                icon: Icon(Icons.map,
                    color: TransportifyColors.primarySwatch[900]),
                onPressed: mapaView == null
                    ? null
                    : () async {
                        itemSeleccionado = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return mapaView;
                            });
                        if (onSelectionChanged != null)
                          onSelectionChanged(itemSeleccionado);
                      },
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
                  onPressed: () => onSelected(itemSeleccionado),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _obtenerListadoCiudades(AsyncSnapshot<QuerySnapshot> snapshot,
      String ciudadSeleccionada, Function(String) onSelectionChanged) {
    if (!snapshot.hasData)
      return const Center(child: const CircularProgressIndicator());

    Set<String> ciudades = snapshot.data.documents
        .map<String>((doc) => doc[atributo_ciudad])
        .toSet();

    return ListView.builder(
      itemCount: ciudades.length,
      itemBuilder: (context, index) {
        String ciudad = ciudades.elementAt(index);
        bool seleccionada = ciudad == ciudadSeleccionada;
        return _obtenerListViewItemCiudad(
            ciudad, seleccionada, onSelectionChanged);
      },
    );
  }

  static Widget _obtenerListadoPuntosWidget(
      AsyncSnapshot<QuerySnapshot> snapshot,
      String ciudadSeleccionada,
      PuntoTransportify puntoSeleccionado,
      Function(PuntoTransportify) onPuntoChanged) {
    var puntosDeLaCiudad = _obtenerPuntosDeLaCiudad(
      puntos: snapshot.data.documents,
      ciudad: ciudadSeleccionada,
    );

    return ListView.builder(
      itemCount: puntosDeLaCiudad.length,
      itemBuilder: (context, index) {
        var punto = puntosDeLaCiudad.elementAt(index);
        return _obtenerListViewItemPunto(
            punto, onPuntoChanged, puntoSeleccionado);
      },
    );
  }

  static Iterable<DocumentSnapshot> _obtenerPuntosDeLaCiudad(
      {Iterable<DocumentSnapshot> puntos, String ciudad}) {
    return puntos.where((punto) => punto[atributo_ciudad] == ciudad);
  }

  static Widget _obtenerListViewItemCiudad(String ciudad,
          [bool seleccionada = false, Function(String) onSelected]) =>
      Datos.obtenerListViewItem(
          item: ciudad,
          displayName: ciudad,
          selected: seleccionada,
          onSelected: onSelected);

  static Widget _obtenerListViewItemPunto(
      DocumentSnapshot snapshot,
      Function(PuntoTransportify) onSelected,
      PuntoTransportify puntoSeleccionado) {
    PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);
    return Datos.obtenerListViewItem(
      item: punto,
      displayName: punto.nombreCompleto,
      onSelected: onSelected,
      selected: punto == puntoSeleccionado,
    );
  }
}
