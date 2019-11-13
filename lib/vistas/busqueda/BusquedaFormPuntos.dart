import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntosBD.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';


import '../PuntosDialog.dart';
import 'BusquedaForm.dart';

abstract class BusquedaFormPuntosState<T extends StatefulWidget>
    extends BusquedaFormState<T> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();

  final Puntos puntos = Puntos();

  BusquedaFormPuntosState({titulo, coleccionBD, textoResultados})
      : super(
            titulo: titulo,
            coleccionBD: coleccionBD,
            textoResultados: textoResultados);

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

    for (DocumentSnapshot document in coleccion) {
      Puntos puntosDocument = Puntos(
        destino: PuntoTransportify.fromReference(
          document[PuntosBD.atributo_destino],
          init: false,
        ),
        origen: PuntoTransportify.fromReference(
          document[PuntosBD.atributo_origen],
          init: false,
        ),
      );
      if (puntosDocument == puntos) {
        listaResultados.add(document);
      }
    }

    return true;
  }
}