import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:intl/intl.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';
import 'package:transportify/util/style.dart';

import 'BusquedaFormCiudades.dart';

class BusquedaPaqueteForm extends StatefulWidget {  
  final Usuario usuario;

  BusquedaPaqueteForm({Key key, this.usuario}) : super(key: key);

  @override
  _BusquedaPaqueteFormState createState() => _BusquedaPaqueteFormState(usuario: usuario);

}

enum ConfirmAction { ACCEPT, CANCEL }

class _BusquedaPaqueteFormState
    extends BusquedaFormCiudadesState<BusquedaPaqueteForm, Paquete> {
  _BusquedaPaqueteFormState({Usuario usuario})
      : super(
            titulo: "Buscar Paquete",
            coleccionBD: "paquetes",
            textoResultados: "Paquetes encontrados", usuario: usuario);

  List<PuntoTransportify> listaPuntosOrigen = List<PuntoTransportify>();
  List<PuntoTransportify> listaPuntosDestino = List<PuntoTransportify>();

  @override
  Future<bool> buscar(BuildContext context, QuerySnapshot snapshot) async {
    List<DocumentSnapshot> coleccion = snapshot.documents;

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

    listaResultados.clear();
    for (DocumentSnapshot snapshot in coleccion) {
      Paquete paquete = Paquete.fromSnapshot(snapshot);
      await paquete.waitForInit();
      var fechaBusqueda = false;
      var date = paquete.fechaEntrega;
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

      if (origen == paquete.origen.ciudad &&
          destino == paquete.destino.ciudad &&
          diff &&
          fechaBusqueda &&
          paquete.viajeAsignado == null) {
        listaPuntosOrigen.add(paquete.origen);
        listaPuntosDestino.add(paquete.destino);
        listaResultados.add(paquete);
      }
    }

    return true;
  }

  @override
  Widget builderListado(BuildContext context, int index) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Wrap(
              direction: Axis.horizontal,
              spacing: 10.0,
              children: [
                Text(
                  listaPuntosOrigen[index].direccion,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Icon(
                  Icons.arrow_forward,
                ),
                Text(
                  listaPuntosDestino[index].direccion,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5.0,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      color: Colors.lightBlue[200],
                      size: 35.0,
                    ),
                    Text(
                      DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, "es_ES")
                          .format(listaResultados[index].fechaEntrega),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 4.0,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'Precio:',
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 18),
                        ),
                        Text(
                          ' ${(listaResultados[index].precio ?? 0) - (listaResultados[index].precio ?? 0) * 0.05 ?? 'No'} €',
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
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 18),
                        ),
                        Text(
                          '${listaResultados[index].peso} kg',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 5.0,
                      children: <Widget>[
                        Text(
                          'Dimensiones: ',
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 18),
                        ),
                        Text(
                          '${listaResultados[index].largo}',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          'x',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          '${listaResultados[index].ancho}',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          'x',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          '${listaResultados[index].alto}',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          'cm',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                    listaResultados[index].fragil ? Text('Frágil', style: TextStyle(color: Colors.red, fontSize: 18),) : const SizedBox(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        _asyncConfirmDialog(context, '¿Desea aceptar este paquete?').then(
            (ConfirmAction value) {
          if (value == ConfirmAction.ACCEPT) {
            Viaje viaje;
            Paquete paquete = listaResultados[index];
            Duration diasMargen = new Duration(days: 1 + paquete.diasMargen);
            DateTime fechaMargen = paquete.fechaEntrega.add(diasMargen);
            showDialog(
                context: context,
                builder: (BuildContext context) => VentanaViaje(
                      origen: paquete.origen.ciudad,
                      destino: paquete.destino.ciudad,
                      fechaPaquete: paquete.fechaEntrega,
                      fechaMargen: fechaMargen,
                    )).then((value) {
              viaje = value;
              if (viaje != null) {
                _asyncConfirmDialog(
                        context, '¿Desea incluir el paquete en este viaje?')
                    .then((ConfirmAction value) {
                  if (value == ConfirmAction.ACCEPT) {
                    paquete.estado = EstadoPaquete.por_recoger;
                    paquete.viajeAsignado = viaje;
                    paquete.updateBD();

                    TransportifyMethods.doneDialog(context, "Paquete vinculado",
                        content: "¡El paquete ha sido asignado con éxito!");

                    //aceptar paquete en viaje

                  }
                }, onError: (error) {
                  print(error);
                });
              }
            });
          }
        }, onError: (error) {
          print(error);
        });
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, String title) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }
}

class VentanaViaje extends StatefulWidget {
  final String origen, destino;
  final DateTime fechaPaquete, fechaMargen;
  VentanaViaje(
      {this.origen, this.destino, this.fechaPaquete, this.fechaMargen});

  @override
  _VentanaViaje createState() => new _VentanaViaje(
      origen: origen,
      destino: destino,
      fechaPaquete: fechaPaquete,
      fechaMargen: fechaMargen);

  static Future<Viaje> show(BuildContext context) async => await showDialog(
      context: context,
      builder: (_) {
        return VentanaViaje();
      });
}

class _VentanaViaje extends State<VentanaViaje> {
  String origen, destino;
  DateTime fechaPaquete, fechaMargen;

  _VentanaViaje(
      {this.origen, this.destino, this.fechaPaquete, this.fechaMargen});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Seleccione el viaje en el que desea llevar el paquete: "),
      content: Container(
          height: 300,
          width: 300,
          child: Center(
            child: ViajeBD.obtenerListadoViajesWidget(
              onSelected: (_viajeSeleccionado) {
                Navigator.pop(context, _viajeSeleccionado);
              },
              filtro: (viaje) =>
                  (origen != null ? origen == viaje.origen : true) &&
                  (destino != null ? destino == viaje.destino : true) &&
                  (fechaPaquete != null
                      ? fechaPaquete.isBefore(viaje.fecha)
                      : true) &&
                  (fechaMargen != null
                      ? fechaMargen.isAfter(viaje.fecha)
                      : true),
            ),
          )),
    );
  }
}
