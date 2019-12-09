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
  final String titulo;

  MapaView._({Key key, this.usuario, this.titulo}) : super(key: key);

  factory MapaView({
    bool puntoSelector,
    Usuario usuario,
    Key key,
  }) {
    if (puntoSelector) return MapaViewPuntos();
    else return MapaViewCiudades();
  }
}

class MapaViewPuntos extends MapaView {
  static const String titulo_puntos = 'Elegir Punto Transportify';

  final PuntoTransportify puntoInicial;

  MapaViewPuntos({Key key, Usuario usuario, this.puntoInicial}) : super._(key: key, titulo: titulo_puntos, usuario: usuario);

  @override
  State<StatefulWidget> createState() => _MapaViewStatePuntos(puntoInicial: puntoInicial); 
}

class MapaViewCiudades extends MapaView {
  static const String titulo_ciudades = 'Elegir Ciudad';

  final String ciudadInicial;

  MapaViewCiudades({Key key, Usuario usuario, this.ciudadInicial}) : super._(key: key, titulo: titulo_ciudades, usuario: usuario);

  @override
  State<StatefulWidget> createState() => _MapaViewStateCiudades(ciudadInicial: ciudadInicial);
}

class _MapaViewStatePuntos extends _MapaViewState<MapaViewPuntos> {
  _MapaViewStatePuntos({PuntoTransportify puntoInicial}) : super(puntoSeleccionado: puntoInicial);
}

class _MapaViewStateCiudades extends _MapaViewState<MapaViewCiudades> {
  _MapaViewStateCiudades({String ciudadInicial}) : super(lugarSeleccionado: ciudadInicial);
}

abstract class _MapaViewState<T extends MapaView> extends State<T> {
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(40.416775, -2.8), zoom: 5);
  Completer<GoogleMapController> _controller = Completer();
  LatLng userLocation;
  MapType type;
  String userCity;
  List<Marker> puntosList = [];
  List<Marker> ciudadList = [];

  String lugarSeleccionado;
  List<PuntoTransportify> listaPuntosTransportify;
  PuntoTransportify puntoSeleccionado;

  _MapaViewState({this.lugarSeleccionado, this.puntoSeleccionado});

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {
      lugarSeleccionado = "";
    });
  }

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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 250,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      markers: (widget is MapaViewPuntos)
                          ? Set<Marker>.of(puntosList)
                          : Set.from(ciudadList),
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
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  SizedBox(width: 15.0),
                  Text(
                      (widget is MapaViewPuntos)
                          ? 'Punto Seleccionado:'
                          : 'Ciudad Seleccionada:',
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  SizedBox(width: 15.0),
                  Text(
                    '$lugarSeleccionado',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
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
                            (widget is MapaViewCiudades)
                                ? Navigator.pop(context, this.lugarSeleccionado)
                                : Navigator.pop(
                                    context, this.puntoSeleccionado);
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
  void initState() async {
    super.initState();
    if (widget is MapaViewPuntos) {
      await initPuntosTransportify();
    }
    initCiudades();

    type = MapType.normal;
    setCameraPosition();
  }

  Future<void> initPuntosTransportify() async {
    Iterable<PuntoTransportify> puntos =
        await PuntoTransportifyBD.obtenerPuntos();
    listaPuntosTransportify = puntos.toList();

    for (var i in listaPuntosTransportify) {
      if (i.direccion != null &&
          i.apodo != null &&
          i.ciudad != null &&
          i.latitud != null &&
          i.longitud != null) {
        puntosList.add(Marker(
            markerId: MarkerId(i.direccion),
            position: new LatLng(i.latitud, i.longitud),
            draggable: false,
            onTap: () {
              setState(() {
                lugarSeleccionado = i.direccion;
                puntoSeleccionado = i;
              });
            }));
      }
    }
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

  void setCameraPosition() {
    for (var i in ciudadList) {
      if (i.markerId.value.compareTo(widget.usuario?.ciudad) == 0) {
        setState(() {
          _initialPosition = CameraPosition(target: i.position, zoom: 8);
        });
      }
    }
  }
}
