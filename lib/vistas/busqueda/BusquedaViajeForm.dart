import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';

import 'BusquedaFormCiudades.dart';

class BusquedaViajeForm extends StatefulWidget {
  BusquedaViajeForm({Key key, this.title, this.usuario}) : super(key: key);
  @override
  _BusquedaViajeFormState createState() => _BusquedaViajeFormState(usuario: usuario);

  final String title;
  final Usuario usuario;
}

class _BusquedaViajeFormState
    extends BusquedaFormCiudadesState<BusquedaViajeForm, Viaje> {
  _BusquedaViajeFormState({Usuario usuario})
      : super(
            titulo: "Buscar Viaje",
            coleccionBD: "viajes",
            textoResultados: "Viajes encontrados",
            usuario: usuario);

  @override
  Future<bool> buscar(BuildContext context, QuerySnapshot snapshot) async {
    List<DocumentSnapshot> coleccion = snapshot.documents;
    listaResultados.clear();

    var now = new DateTime.now();
    DateTime fechaElegida;
    if (choosenDate != null && choosenTime != null) {
      fechaElegida = new DateTime(choosenDate.year, choosenDate.month,
          choosenDate.day, choosenTime.hour, choosenTime.minute, 0);
    } else if (choosenTime == null && choosenDate != null) {
      fechaElegida = new DateTime(
          choosenDate.year, choosenDate.month, choosenDate.day, 0, 0, 0);
    } else {
      fechaElegida = now;
    }

    for (DocumentSnapshot snapshot in coleccion) {
      Viaje viaje = Viaje.fromSnapshot(snapshot);

      await viaje.waitForInit();

      var date = viaje.fecha;
      var fechaBusqueda = false;
      var diff = date.isAfter(now);

      if (date.day == fechaElegida.day &&
              date.month == fechaElegida.month &&
              date.year == fechaElegida.year &&
              choosenTime == null ||
          choosenDate == null) {
        fechaBusqueda = true;
      } else if (choosenTime != null &&
          date.hour == fechaElegida.hour &&
          date.minute == fechaElegida.minute) {
        fechaBusqueda = true;
      }

      if (origen == viaje.origen &&
          destino == viaje.destino &&
          fechaBusqueda &&
          diff && !viaje.cancelado) {
        listaResultados.add(viaje);
      }
    }

    return true;
  }

  @override
  Widget builderListado(BuildContext context, int index) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 7.0,
                    ),
                    Icon(
                      Icons.airport_shuttle,
                      color: Colors.lightBlue[200],
                      size: 50.0,
                    ),
                  ],
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${listaResultados[index].transportista?.nombre ?? 'No establecido'}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${listaResultados[index].cargaMaxima} kg',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, "es_ES")
                          .format(listaResultados[index].fecha),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      DateFormat.Hm().format(listaResultados[index].fecha),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ]),
        ),
      ),
      onTap: () {
        print('Has seleccionado un viaje');
      },
    );
  }
}
