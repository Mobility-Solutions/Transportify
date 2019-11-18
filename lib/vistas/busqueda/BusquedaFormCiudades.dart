import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/CiudadDialog.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'BusquedaForm.dart';

abstract class BusquedaFormCiudadesState<T extends StatefulWidget>
    extends BusquedaFormState<T> {
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final horaController = TextEditingController();
  final fechaController = TextEditingController();

  String origen, destino;
  DateTime choosenDate, choosenTime;

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
        SizedBox(
          height: 20.0,
        ),
        
        /** 
                 * *******************
                 * SELECTOR DE FECHA *
                 * *******************
                 * */
                  TextFormField(
                    
                    maxLines: 1,
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
                        String _date =
                            '${date.day} / ${date.month} / ${date.year}';
                        setState(() {
                          fechaController.text = _date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.es);
                    },
                    keyboardType: TextInputType.datetime,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    decoration: TransportifyMethods.returnTextFormDecoration(
                        "Seleccionar fecha"),
                  ),
                  
                  /** 
                 * ******************
                 * SELECTOR DE HORA *
                 * ******************
                 * */
                  TextFormField(
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
                    decoration: TransportifyMethods.returnTextFormDecoration(
                        "Seleccionar hora"),
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                  ),

      ],
    );
  }
}
