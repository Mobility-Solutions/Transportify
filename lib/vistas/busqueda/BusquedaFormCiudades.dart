import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/CiudadDialog.dart';


import 'BusquedaForm.dart';

abstract class BusquedaFormCiudadesState<T extends StatefulWidget, R>
    extends BusquedaFormState<T, R> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();

  String origen, destino;

  BusquedaFormCiudadesState({titulo, coleccionBD, textoResultados})
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
              "Ciudad de origen"),
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
              "Ciudad de destino"),
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
}
