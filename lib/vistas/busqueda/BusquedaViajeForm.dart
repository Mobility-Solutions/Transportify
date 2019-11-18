import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportify/middleware/ViajeBD.dart';

import 'BusquedaFormCiudades.dart';

class BusquedaViajeForm extends StatefulWidget {
  BusquedaViajeForm({Key key, this.title}) : super(key: key);
  @override
  _BusquedaViajeFormState createState() => _BusquedaViajeFormState();

  final String title;
}

class _BusquedaViajeFormState extends BusquedaFormCiudadesState<BusquedaViajeForm> {
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

    var now = new DateTime.now();
    DateTime fechaElegida;
    if(choosenDate != null && choosenTime != null){
    fechaElegida = new DateTime(
        choosenDate.year,
        choosenDate.month,
        choosenDate.day,
        choosenTime.hour,
        choosenTime.minute,
        0);
    }
    else if (choosenTime == null && choosenDate != null){
      fechaElegida = new DateTime(
        choosenDate.year,
        choosenDate.month,
        choosenDate.day,
        0,
        0,
        0);
    }
    else{
      fechaElegida = now;
    }

    for (DocumentSnapshot snapshot in coleccion) {
      String origenBD = ViajeBD.obtenerOrigen(snapshot);
      String destinoBD = ViajeBD.obtenerDestino(snapshot);

      var date = snapshot[ViajeBD.atributo_fecha].toDate();
      var fechaBusqueda = date.isAfter(fechaElegida);
      var diff = date.isAfter(now);

      if (origen == origenBD && destino == destinoBD && fechaBusqueda && diff) {
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
                            '${listaResultados[index]['id_transportista'] ?? 'No'}',
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
                            '${listaResultados[index]['carga_maxima']} kg',
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
