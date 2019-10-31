import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

import 'PuntosDialog.dart';

class PaqueteListView extends StatefulWidget {
  @override
  _PaqueteListViewState createState() => _PaqueteListViewState();
}

class _PaqueteListViewState extends State<PaqueteListView> {
  int paquetesEncontrados;
  List<DocumentSnapshot> listaPaquetes = List<DocumentSnapshot>();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final Puntos puntos = Puntos();
  bool visibilityList = false;
  Text textoNPaquetes;
  Visibility listaResultado;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Buscar Paquete"),
          backgroundColor: TransportifyColors.primarySwatch,
        ),
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
                decoration:
                    TransportifyMethods.returnTextFormDecoration("Punto Transportify de origen"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  PuntoTransportify returnPunto =
                      await PuntosDialog.show(this.context);

                  if (returnPunto != null) {
                    puntos.origen = returnPunto;
                    origenController.text = puntos.origen?.nombre;
                  }
                },
                validator: (value) => validarPuntos(),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                maxLines: 1,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                controller: destinoController,
                decoration:
                    TransportifyMethods.returnTextFormDecoration("Punto Transportify de destino"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  PuntoTransportify returnPunto =
                      await PuntosDialog.show(this.context);

                  if (returnPunto != null) {
                    puntos.destino = returnPunto;
                    destinoController.text = puntos.destino?.nombre;
                  }
                },
                validator: (value) => validarPuntos(),
              ),
              Container(
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
                              'Paquetes encontrados:  ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            visibilityList
                                ? textoNPaquetes = new Text(
                                    '$paquetesEncontrados',
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
              visibilityList
                  ? new Expanded(
                      child: listaResultado = new Visibility(
                        visible: visibilityList,
                        child: sacarListaPaquetes(),
                      ),
                    )
                  : new Container(),
            ],
          ),
        ),
        backgroundColor: TransportifyColors.primarySwatch,
      ),
    );
  }

  String validarPuntos() {
    String res = puntos.validate();
    if (res == null) {
      visibilityList = true;
    } else {
      visibilityList = false;
      listaPaquetes.clear();
    }
    return res;
  }

  void _onChangedVisibility(bool visibility) {
    setState(() {
      if (_formKey.currentState.validate()) {
        paquetesEncontrados = listaPaquetes.length;
        listaPaquetes.clear();
      }
    });
  }

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD('paquetes', builder);
  }

  Widget sacarListaPaquetes() {
    return obtenerStreamBuilderListado(obtenerListaBuilder());
  }

  Function(BuildContext, AsyncSnapshot<QuerySnapshot>) obtenerListaBuilder() {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _sacarListaPaquetes(context, snapshot);
    };
  }

  Widget _sacarListaPaquetes(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return const Text('Cargando...');
    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaPaquetes.clear();
    for (int i = 0; i < coleccion.length; i++) {
      if (coleccion[i]['id_destino'].toString() == puntos.destino.id &&
          coleccion[i]['id_origen'].toString() == puntos.origen.id) {
        listaPaquetes.add(coleccion[i]);
      }
    }
    paquetesEncontrados = listaPaquetes.length;

    return ListView.separated(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      itemCount: listaPaquetes.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Center(
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Precio:',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ),
                          Text(
                            ' ${listaPaquetes[index]['Precio']}',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Peso: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ),
                          Text(
                            '${listaPaquetes[index]['peso']}',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Frágil: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ),
                          Text(
                            '${listaPaquetes[index]['fragil']}',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Alto: ',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ),
                          Text(
                            '${listaPaquetes[index]['alto']} cm',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Ancho: ',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ),
                          Text(
                            '${listaPaquetes[index]['ancho']} cm',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Largo: ',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ),
                          Text(
                            '${listaPaquetes[index]['largo']} cm',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            print('Has pulsado un paquete');
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
