import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/util/style.dart';

abstract class MapaView extends StatefulWidget {
  final Usuario usuario;
  final String titulo, mensajeSeleccion;

  MapaView._({Key key, this.usuario, this.titulo, this.mensajeSeleccion})
      : super(key: key);

  factory MapaView({
    bool puntoSelector,
    Usuario usuario,
    Key key,
  }) {
    if (puntoSelector)
      return MapaViewPuntos();
    else
      return MapaViewCiudades();
  }
}

class MapaViewPuntos extends MapaView {
  static const String titulo_puntos = 'Elegir Punto Transportify',
      mensaje_seleccion = 'Punto seleccionado:';

  final PuntoTransportify puntoInicial;

  MapaViewPuntos({Key key, Usuario usuario, this.puntoInicial})
      : super._(
            key: key,
            titulo: titulo_puntos,
            mensajeSeleccion: mensaje_seleccion,
            usuario: usuario);

  @override
  State<StatefulWidget> createState() =>
      _MapaViewStatePuntos(puntoInicial: puntoInicial);
}

class MapaViewCiudades extends MapaView {
  static const String titulo_ciudades = 'Elegir Ciudad',
      mensaje_seleccion = 'Ciudad seleccionada:';

  final String ciudadInicial;

  MapaViewCiudades({Key key, Usuario usuario, this.ciudadInicial})
      : super._(
            key: key,
            titulo: titulo_ciudades,
            mensajeSeleccion: mensaje_seleccion,
            usuario: usuario);

  @override
  State<StatefulWidget> createState() =>
      _MapaViewStateCiudades(ciudadInicial: ciudadInicial);
}

class _MapaViewStatePuntos
    extends _MapaViewState<MapaViewPuntos, PuntoTransportify> {
  List<PuntoTransportify> listaPuntosTransportify;

  _MapaViewStatePuntos({PuntoTransportify puntoInicial})
      : super(
            latitudInicial: puntoInicial?.latitud,
            longitudInicial: puntoInicial?.longitud);

  @override
  Iterable<PuntoTransportify> obtenerListado(
      Iterable<DocumentSnapshot> snapshots) {
    var listado =
        snapshots.map((snapshot) => PuntoTransportify.fromSnapshot(snapshot));

    // Actualiza el Punto seleccionado (si lo hubiera)
    if (itemSeleccionado != null) {
      itemSeleccionado = listado.firstWhere((item) => item == itemSeleccionado,
          orElse: () => null);
    }

    return listado;
  }

  @override
  Set<Marker> obtenerMarkers(
      Iterable<PuntoTransportify> listaPuntosTransportify) {
    List<Marker> puntosList = List<Marker>();
    for (var punto in listaPuntosTransportify) {
      if (punto.direccion != null &&
          punto.apodo != null &&
          punto.ciudad != null &&
          punto.latitud != null &&
          punto.longitud != null) {
        puntosList.add(Marker(
            markerId: MarkerId(punto.direccion),
            position: new LatLng(punto.latitud, punto.longitud),
            draggable: false,
            onTap: () {
              setState(() {
                itemSeleccionado = punto;
              });
            }));
      }
    }
    return Set<Marker>.of(puntosList);
  }
}

class _MapaViewStateCiudades extends _MapaViewState<MapaViewCiudades, String> {
  // TODO: Añadir super() con coordenadas ciudad inicial
  _MapaViewStateCiudades({String ciudadInicial}) {
    _initMapCoordenadas();
  }

  @override
  Iterable<String> obtenerListado(Iterable<DocumentSnapshot> snapshots) {
    return snapshots
        .map((snapshot) => PuntoTransportify.fromSnapshot(snapshot))
        .map((punto) => punto.ciudad);
  }

  Map<String, LatLng> mapCoordenadas = Map<String, LatLng>();

  @override
  Set<Marker> obtenerMarkers(Iterable<String> ciudades) {
    List<Marker> ciudadList = List<Marker>();
    for (String ciudad in ciudades) {
      if (mapCoordenadas.containsKey(ciudad)) {
        ciudadList.add(_crearMarker(ciudad));
      }
    }
    return Set.of(ciudadList);
  }

  Marker _crearMarker(String ciudad) => Marker(
      markerId: MarkerId(ciudad),
      position: mapCoordenadas[ciudad],
      draggable: false,
      onTap: () {
        setState(() {
          itemSeleccionado = ciudad;
        });
      });

  // TODO: Quitar este método y guardar las coordenadas en la BD
  void _initMapCoordenadas() {
    mapCoordenadas["Valencia"] = LatLng(39.4697500, -0.3773900);
    mapCoordenadas["Barcelona"] = LatLng(41.3887901, 2.1589899);
    mapCoordenadas["Toledo"] = LatLng(39.8581000, -4.0226300);
    mapCoordenadas["Madrid"] = LatLng(40.4165000, -3.7025600);
    mapCoordenadas["Segovia"] = LatLng(40.9480800, -4.1183900);
    mapCoordenadas["Sevilla"] = LatLng(37.3828300, -5.9731700);
    mapCoordenadas["Santiago de Compostela"] = LatLng(42.890528, -8.526583);
  }
}

abstract class _MapaViewState<T extends MapaView, K> extends State<T> {
  CameraPosition _initialPosition;
  Completer<GoogleMapController> _controller = Completer();
  MapType type;

  K itemSeleccionado;
  String get ciudadUsuario => widget.usuario?.ciudad;

  // TODO: Añadir coordenadas ciudad usuario si no se indican
  _MapaViewState({double latitudInicial, double longitudInicial})
      : _initialPosition = CameraPosition(
            target:
                LatLng(latitudInicial ?? 40.416775, longitudInicial ?? -2.8),
            zoom: latitudInicial != null && longitudInicial != null ? 8 : 5);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Iterable<K> obtenerListado(Iterable<DocumentSnapshot> snapshots);
  Set<Marker> obtenerMarkers(Iterable<K> items);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.titulo),
          backgroundColor: TransportifyColors.primarySwatch,
          centerTitle: true,
        ),
        body: Container(
          color: TransportifyColors.primarySwatch,
          child: PuntoTransportifyBD.obtenerStreamBuilderListado(
              (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: const CircularProgressIndicator());

            Iterable<K> listado = obtenerListado(snapshot.data.documents);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: GoogleMap(
                          markers: obtenerMarkers(listado),
                          mapType: type,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: _initialPosition,
                        ),
                      ),
                      Positioned(
                        top: 30.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              type = (type == MapType.hybrid)
                                  ? MapType.normal
                                  : MapType.hybrid;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: TransportifyColors.primarySwatch[900],
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: TransportifyColors.primarySwatch)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.terrain,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(widget.mensajeSeleccion,
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                      SizedBox(height: 5.0),
                      Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Text(
                            '${itemSeleccionado?.toString() ?? ''}',
                            maxLines: 6,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        extendBody: false,
        bottomNavigationBar: new Stack(
          overflow: Overflow.visible,
          alignment: new FractionalOffset(10, 0.5),
          children: [
            new Container(
                height: 80.0, color: TransportifyColors.primarySwatch),
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TransportifyFormButton(
                          text: 'Cancelar',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TransportifyFormButton(
                          text: 'Guardar',
                          onPressed: () {
                            Navigator.pop(context, this.itemSeleccionado);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ]),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    type = MapType.normal;
  }
}
