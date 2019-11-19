import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Viaje.dart';

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
        Viaje viaje;
        _asyncConfirmDialog(context, '¿Desea aceptar este paquete?').then(
            (ConfirmAction value) {
          if (value == ConfirmAction.ACCEPT) {
            print("has seleccionado un paquete: " + index.toString());
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    VentanaViaje()).then((value) {
              viaje = value;
              _asyncConfirmDialog(context, '¿Desea incluir el paquete en este viaje?')
                  .then((ConfirmAction value) {
                    if (value == ConfirmAction.ACCEPT) {
                      print("se incluyo el paquete");

                    }
                  }, onError: (error) {
                print(error);
              });
            }
                //Viaje viaje = await showDialog(context: context, builder: (BuildContext context) => VentanaViaje())
                );
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
  @override
  _VentanaViaje createState() => new _VentanaViaje();

  static Future<Viaje> show(BuildContext context) async => await showDialog(
      context: context,
      builder: (_) {
        return VentanaViaje();
      });
}

class _VentanaViaje extends State<VentanaViaje> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Seleccione el viaje en el que desea llevar el paquete: "),
      content: Container(
          height: 300,
          width: 300,
          child: Center(
            child: ViajeBD.obtenerListadoViajes_widget(
                onSelected: (_viajeSeleccionado) {
              Navigator.pop(context, _viajeSeleccionado);
            }),
          )),
    );
  }
}
