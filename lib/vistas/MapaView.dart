import 'dart:async';

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
  List<Marker> puntosList = [];
  List<PuntoTransportify> listaPuntosTransportify;
  PuntoTransportify puntoSeleccionado;

  @override
  PuntoTransportify get seleccion => puntoSeleccionado;

  _MapaViewStatePuntos({PuntoTransportify puntoInicial})
      : super(
            latitudInicial: puntoInicial?.latitud,
            longitudInicial: puntoInicial?.longitud);

  @override
  Set<Marker> obtenerMarkers() => Set<Marker>.of(puntosList);

  @override
  void initState() {
    _initPuntosTransportify();
    super.initState();
  }

  Future<void> _initPuntosTransportify() async {
    Iterable<PuntoTransportify> puntos =
        await PuntoTransportifyBD.obtenerPuntos();
    listaPuntosTransportify = puntos.toList();

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
                lugarSeleccionado = punto.nombreCompleto;
                puntoSeleccionado = punto;
              });
            }));
      }
    }
  }
}

class _MapaViewStateCiudades extends _MapaViewState<MapaViewCiudades, String> {
  @override
  String get seleccion => lugarSeleccionado;

  // TODO: Añadir super() con coordenadas ciudad inicial
  _MapaViewStateCiudades({String ciudadInicial});

  @override
  Set<Marker> obtenerMarkers() => Set.from(ciudadList);
}

abstract class _MapaViewState<T extends MapaView, K> extends State<T> {
  CameraPosition _initialPosition;
  Completer<GoogleMapController> _controller = Completer();
  MapType type;

  List<Marker> ciudadList = [];
  String lugarSeleccionado;

  K get seleccion;
  String get ciudadUsuario => widget.usuario?.ciudad;

  // TODO: Añadir coordenadas ciudad usuario si no se indican
  _MapaViewState({double latitudInicial, double longitudInicial})
      : _initialPosition = CameraPosition(
            target:
                LatLng(latitudInicial ?? 40.416775, longitudInicial ?? -2.8),
            zoom: latitudInicial != null && longitudInicial != null ? 8 : 5);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {
      lugarSeleccionado = "";
    });
  }

  Set<Marker> obtenerMarkers();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: GoogleMap(
                        markers: obtenerMarkers(),
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
                          '$lugarSeleccionado',
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
          ),
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
                            if (this.lugarSeleccionado == "") {
                              lugarSeleccionado = null;
                            }
                            Navigator.pop(context, this.seleccion);
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
    initCiudades();

    type = MapType.normal;
  }

  void initCiudades() {
    ciudadList.add(
      Marker(
          markerId: MarkerId("Valencia"),
          position: new LatLng(39.4697500, -0.3773900),
          draggable: false,
          onTap: () {
            setState(() {
              lugarSeleccionado = "Valencia";
            });
          }),
    );
    ciudadList.add(
      Marker(
          markerId: MarkerId("Barcelona"),
          position: new LatLng(41.3887901, 2.1589899),
          draggable: false,
          onTap: () {
            setState(() {
              lugarSeleccionado = "Barcelona";
            });
          }),
    );
    ciudadList.add(
      Marker(
          markerId: MarkerId("Toledo"),
          position: new LatLng(39.8581000, -4.0226300),
          draggable: false,
          onTap: () {
            setState(() {
              lugarSeleccionado = "Toledo";
            });
          }),
    );
    ciudadList.add(
      Marker(
          markerId: MarkerId("Madrid"),
          position: new LatLng(40.4165000, -3.7025600),
          draggable: false,
          onTap: () {
            setState(() {
              lugarSeleccionado = "Madrid";
            });
          }),
    );
    ciudadList.add(
      Marker(
          markerId: MarkerId("Segovia"),
          position: new LatLng(40.9480800, -4.1183900),
          draggable: false,
          onTap: () {
            setState(() {
              lugarSeleccionado = "Segovia";
            });
          }),
    );
    ciudadList.add(
      Marker(
          markerId: MarkerId("Sevilla"),
          position: new LatLng(37.3828300, -5.9731700),
          draggable: false,
          onTap: () {
            setState(() {
              lugarSeleccionado = "Sevilla";
            });
          }),
    );
    ciudadList.add(
      Marker(
          markerId: MarkerId("Santiago de Compostela"),
          position: new LatLng(42.890528, -8.526583),
          draggable: false,
          onTap: () {
            setState(() {
              lugarSeleccionado = "Santiago de Compostela";
            });
          }),
    );
  }
}
