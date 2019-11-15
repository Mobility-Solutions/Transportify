import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/CiudadDialog.dart';

import 'BusquedaForm.dart';

class BusquedaViajeForm extends StatefulWidget {
  BusquedaViajeForm({Key key, this.title}) : super(key: key);
  @override
  _BusquedaViajeFormState createState() => _BusquedaViajeFormState();

  final String title;
}

class _BusquedaViajeFormState extends BusquedaFormState<BusquedaViajeForm> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();

  String origen, destino;

  _BusquedaViajeFormState()
      : super(
            titulo: "Buscar Viaje",
            coleccionBD: "viajes",
            textoResultados: "Viajes encontrados");

  @override
  Widget buildSelectorBusqueda(BuildContext context) {
    return Column(
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
            String returnCiudad = await CiudadDialog.show(this.context);

            if (returnCiudad != null) {
              origen = returnCiudad;
              origenController.text = origen;
            }
          },
          validator: (value) {
            if (origen == null || destino == null)
              return 'Introduzca las ciudades origen y destino';
            else if (origen == destino)
              return 'Las ciudades no deben coincidir.';
            else
              return null;
          },
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
            String returnCiudad = await CiudadDialog.show(this.context);

            if (returnCiudad != null) {
              destino = returnCiudad;
              destinoController.text = destino;
            }
          },
          validator: (value) {
            if (origen == null || destino == null)
              return 'Introduzca las ciudades origen y destino';
            else if (origen == destino)
              return 'Las ciudades no deben coincidir.';
            else
              return null;
          },
        ),
      ],
    );
  }

  @override
  bool buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return false;

    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaResultados.clear();

    for (DocumentSnapshot snapshot in coleccion) {
      String origenBD = ViajeBD.obtenerOrigen(snapshot);
      String destinoBD = ViajeBD.obtenerDestino(snapshot);

      if (origen == origenBD && destino == destinoBD) {
        listaResultados.add(snapshot);
      }
    }

    return true;
  }

  @override
  Widget builderListado(BuildContext context, int index) {
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
                            '${listaResultados[index]['id_transportista']}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.black, height: 2.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${listaResultados[index]['carga_maxima']}',
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
                          DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, "es_ES")
                              .format(listaResultados[0]['fecha'].toDate()),
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, height: 2.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateFormat.Hm()
                              .format(listaResultados[0]['fecha'].toDate()),
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
  }
}
