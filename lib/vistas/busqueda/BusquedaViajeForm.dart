import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportify/modelos/Viaje.dart';

import 'BusquedaFormCiudades.dart';

class BusquedaViajeForm extends StatefulWidget {
  BusquedaViajeForm({Key key, this.title}) : super(key: key);
  @override
  _BusquedaViajeFormState createState() => _BusquedaViajeFormState();

  final String title;
}

class _BusquedaViajeFormState extends BusquedaFormCiudadesState<BusquedaViajeForm, Viaje> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();

  String origen, destino;

  _BusquedaViajeFormState()
      : super(
            titulo: "Buscar Viaje",
            coleccionBD: "viajes",
            textoResultados: "Viajes encontrados");

  @override
  Future<bool> buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) async {
    if (!snapshot.hasData) return false;

    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaResultados.clear();

    for (DocumentSnapshot snapshot in coleccion) {
      Viaje viaje = Viaje.fromSnapshot(snapshot);

      if (origen == viaje.origen && destino == viaje.destino) {
        listaResultados.add(viaje);
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
                            '${listaResultados[index].transportista?.nombre ?? 'No establecido'}',
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
                            '${listaResultados[index].cargaMaxima}',
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
                              .format(listaResultados[0].fecha),
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
                              .format(listaResultados[0].fecha),
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
