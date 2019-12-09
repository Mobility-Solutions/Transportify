import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/util/style.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:transportify/vistas/MapaView.dart';
import 'package:transportify/vistas/dialog/CiudadDialog.dart';

import 'BusquedaForm.dart';

abstract class BusquedaFormCiudadesState<T extends StatefulWidget, R>
    extends BusquedaFormState<T, R> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final horaController = TextEditingController();
  final fechaController = TextEditingController();

  Usuario usuario;
  String origen, destino;
  DateTime choosenDate, choosenTime;
  BusquedaFormCiudadesState({
    String titulo,
    String coleccionBD,
    String textoResultados,
    this.usuario,
  })  : origen = usuario.ciudad,
        super(
            titulo: titulo,
            coleccionBD: coleccionBD,
            textoResultados: textoResultados) {
    if (origen != null) origenController.text = origen;
  }

  //Abre la página del mapa y a la vuelta de la misma, le pasa la ciudad seleccionada al controlador indicado
  getCiudadSeleccionada(BuildContext context, bool origenLocation) async {
    final String ciudadSeleccionada =
        await Navigator.of(context).push<String>(MaterialPageRoute(
            builder: (context) => MapaViewCiudades(
                  usuario: usuario,
                  ciudadInicial: origenLocation ? origen : destino,
                )));

    if (origenLocation) {
      if (ciudadSeleccionada != null) {
        origen = ciudadSeleccionada;
        origenController.text = origen;
      }
    } else {
      if (ciudadSeleccionada != null) {
        destino = ciudadSeleccionada;
        destinoController.text = destino;
      }
    }
  }

  @override
  Widget buildSelectorBusqueda(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Container(
              width: 250.0,
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                controller: origenController,
                decoration:
                    TransportifyMethods.returnTextFormDecoration("Ciudad de origen"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  String returnCiudad =
                      await CiudadDialog.show(this.context, ciudadInicial: origen);

                  if (returnCiudad != null) {
                    origen = returnCiudad;
                    origenController.text = origen;
                  }
                },
                validator: (value) {
                  if (origen == null)
                    return 'Introduzca la ciudad de origen';
                  else if (origen == destino)
                    return 'Las ciudades no deben coincidir.';
                  else
                    return null;
                },
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            IconButton(
              color: TransportifyColors.primarySwatch,
              icon: Icon(Icons.map, color: Colors.white),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                getCiudadSeleccionada(context, true);
              },
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Container(
              width: 250.0,
              child: TextFormField(
                maxLines: 1,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                controller: destinoController,
                decoration:
                    TransportifyMethods.returnTextFormDecoration("Ciudad de destino"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  String returnCiudad =
                      await CiudadDialog.show(this.context, ciudadInicial: destino);

                  if (returnCiudad != null) {
                    destino = returnCiudad;
                    destinoController.text = destino;
                  }
                },
                validator: (value) {
                  if (destino == null)
                    return 'Introduzca la ciudad de destino';
                  else if (origen == destino)
                    return 'Las ciudades no deben coincidir.';
                  else
                    return null;
                },
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            IconButton(
              color: TransportifyColors.primarySwatch,
              icon: Icon(Icons.map, color: Colors.white),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                getCiudadSeleccionada(context, false);
              },
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: TextFormField(
                //maxLines: 1,
                controller: fechaController,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 200.0,
                      ),
                      minTime: new DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 1),
                      maxTime: new DateTime(DateTime.now().year + 3),
                      showTitleActions: true, onConfirm: (date) {
                    choosenDate = date;
                    String _date = '${date.day} / ${date.month} / ${date.year}';
                    setState(() {
                      fechaController.text = _date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                keyboardType: TextInputType.datetime,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                decoration:
                    TransportifyMethods.returnTextFormDecoration("Fecha"),
              ),
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                maxLines: 1,
                controller: horaController,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 200.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    print('confirm $time');
                    choosenTime = time;
                    String _time = DateFormat.Hm().format(time);
                    setState(() {
                      horaController.text = _time;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                decoration:
                    TransportifyMethods.returnTextFormDecoration("Hora"),
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
              ),
            ),
          ],
        )
      ],
    );
  }
}
