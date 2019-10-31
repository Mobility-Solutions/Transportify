import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/vistas/BusquedaForm.dart';

import 'PuntosDialog.dart';

class PaqueteListView extends StatefulWidget {
  @override
  _PaqueteListViewState createState() => _PaqueteListViewState();
}

class _PaqueteListViewState extends BusquedaFormState<PaqueteListView> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();

  final Puntos puntos = Puntos();

  _PaqueteListViewState()
      : super(
            titulo: "Buscar Paquete",
            atributoBD: "paquetes",
            textoResultados: "Paquetes encontrados");

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
          validator: (value) => puntos.validate(),
        ),
      ],
    );
  }

  @override
  bool buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return false;
    
    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaResultados.clear();

    for (int i = 0; i < coleccion.length; i++) {
      if (coleccion[i]['id_destino'].toString() == puntos.destino?.id &&
          coleccion[i]['id_origen'].toString() == puntos.origen?.id) {
        listaResultados.add(coleccion[i]);
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
                        ' ${listaResultados[index]['Precio']}',
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
                        '${listaResultados[index]['peso']}',
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
                        '${listaResultados[index]['fragil']}',
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
                        '${listaResultados[index]['alto']} cm',
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
                        '${listaResultados[index]['ancho']} cm',
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
                        '${listaResultados[index]['largo']} cm',
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
  }
}
