import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';
import 'package:transportify/util/style.dart';

import 'BusquedaFormCiudades.dart';

class BusquedaPaqueteForm extends StatefulWidget {
  @override
  _BusquedaPaqueteFormState createState() => _BusquedaPaqueteFormState();
}

enum ConfirmAction { ACCEPT, CANCEL }

class _BusquedaPaqueteFormState
    extends BusquedaFormCiudadesState<BusquedaPaqueteForm, Paquete> {
  _BusquedaPaqueteFormState()
      : super(
            titulo: "Buscar Paquete",
            coleccionBD: "paquetes",
            textoResultados: "Paquetes encontrados");

  @override
  Future<bool> buscar(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) async {
    if (!snapshot.hasData) return false;

    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaResultados.clear();

    for (DocumentSnapshot snapshot in coleccion) {
      Paquete paquete = Paquete.fromSnapshot(snapshot);
      await paquete.waitForInit();

      if (origen == paquete.origen.ciudad &&
          destino == paquete.destino.ciudad) {
        listaResultados.add(paquete);
      }
    }

    return true;
  }

  @override
  Widget builderListado(BuildContext context, int index) {
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
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        ' ${listaResultados[index].precio ?? 'No establecido'}',
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
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index].peso}',
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
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        listaResultados[index].fragil ? 'Sí' : 'No',
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
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index].alto} cm',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Ancho: ',
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index].ancho} cm',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Largo: ',
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index].largo} cm',
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
        _asyncConfirmDialog(context, '¿Desea aceptar este paquete?').then(
            (ConfirmAction value) {
          if (value == ConfirmAction.ACCEPT) {
            Viaje viaje;
            Paquete paquete = listaResultados[index];
            showDialog(
                context: context,
                builder: (BuildContext context) => VentanaViaje(
                      origen: paquete.origen.ciudad,
                      destino: paquete.destino.ciudad,
                    )).then((value) {
              viaje = value;
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

  VentanaViaje({this.origen, this.destino});

  @override
  _VentanaViaje createState() =>
      new _VentanaViaje(origen: origen, destino: destino);

  static Future<Viaje> show(BuildContext context) async => await showDialog(
      context: context,
      builder: (_) {
        return VentanaViaje();
      });
}

class _VentanaViaje extends State<VentanaViaje> {
  String origen, destino;

  _VentanaViaje({this.origen, this.destino});

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
                  (destino != null ? destino == viaje.destino : true),
            ),
          )),
    );
  }
}
