import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/util/style.dart';
import '../middleware/Datos.dart';
import 'package:intl/intl.dart';

import 'PuntosDialog.dart';

class ViajeListView extends StatefulWidget {
  ViajeListView({Key key, this.title}) : super(key: key);
  @override
  ViajeListViewState createState() => ViajeListViewState();

  final String title;
}

class ViajeListViewState extends State<ViajeListView> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final Puntos puntos = Puntos();
  List<DocumentSnapshot> listaViajes = List<DocumentSnapshot>();
  final _formKey = GlobalKey<FormState>();
  int viajesEncontrados;
  bool visibilityList = false;
  Text textoNViajes;
  Visibility listaResultado;

  StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD('viajes', builder);
  }

  Widget sacarListaViajes() {
    return obtenerStreamBuilderListado(obtenerListaBuilder());
  }

  void _onChangedVisibility(bool visibility) {
    setState(() {
      if (_formKey.currentState.validate()) {
        viajesEncontrados = listaViajes.length;
        listaViajes.clear();
      }
    });
  }

  Function(BuildContext, AsyncSnapshot<QuerySnapshot>) obtenerListaBuilder() {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _sacarListaViajes(context, snapshot);
    };
  }

  Widget _sacarListaViajes(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return const Text('Cargando...');
    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaViajes.clear();
    for (int i = 0; i < coleccion.length; i++) {
      if (coleccion[i]['id_destino'].toString() == puntos.destino.id &&
          coleccion[i]['id_origen'].toString() == puntos.origen.id) {
        listaViajes.add(coleccion[i]);
      }
    }
    viajesEncontrados = listaViajes.length;
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        separatorBuilder: (context, index) => Divider(
              color: TransportifyColors.primarySwatch,
            ),
        itemCount: listaViajes.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.0),
                          ),
                          Icon(
                            Icons.airport_shuttle,
                            color: Colors.lightBlue[200],
                            size: 50.0,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${listaViajes[index]['id_transportista']}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      height: 2.5),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${listaViajes[index]['carga_maxima']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    height: 0.8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY,
                                        "es_ES")
                                    .format(listaViajes[0]['fecha'].toDate()),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    height: 2.5),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                DateFormat.Hm()
                                    .format(listaViajes[0]['fecha'].toDate()),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  height: 0.8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            onTap: () {
              print('Has seleccionado un viaje');
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Buscar Viaje"),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
        backgroundColor: TransportifyColors.primarySwatch,
        body: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                controller: origenController,
                decoration: TransportifyMethods.returnTextFormDecoration(
                    "Punto Transportify de origen"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  PuntoTransportify returnPunto =
                      await PuntosDialog.show(this.context);

                  if (returnPunto != null) {
                    puntos.origen = returnPunto;
                    origenController.text = puntos.origen?.nombre;
                  }
                },
                validator: (value) => puntos.validate(),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                maxLines: 1,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                controller: destinoController,
                decoration: TransportifyMethods.returnTextFormDecoration(
                    "Punto Transportify de destino"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  PuntoTransportify returnPunto =
                      await PuntosDialog.show(this.context);

                  if (returnPunto != null) {
                    puntos.destino = returnPunto;
                    destinoController.text = puntos.destino?.nombre;
                  }
                },
                validator: (value) {
                  String res = puntos.validate();
                  if (res == null) {
                    visibilityList = true;
                  } else {
                    visibilityList = false;
                    listaViajes.clear();
                  }
                  return res;
                },
              ),
              SafeArea(
                left: true,
                right: true,
                top: true,
                bottom: true,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Viajes encontrados:  ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              visibilityList
                                  ? textoNViajes = new Text(
                                      '$viajesEncontrados',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  : new Container(),
                            ],
                          )),
                      Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: TransportifyColors.primarySwatch[900],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () {
                            print('botón pulsado');
                            _onChangedVisibility(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              visibilityList
                  ? new Expanded(
                      child: listaResultado = new Visibility(
                        visible: visibilityList,
                        child: sacarListaViajes(),
                      ),
                    )
                  : new Container(),
            ],
          ),
        ),
      ),
    );
  }
}
