import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:transportify/modelos/DatosUsuarioActual.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/util/style.dart';

import '../CiudadDialog.dart';

class CreacionViajeForm extends StatefulWidget {
  CreacionViajeForm({Key key, this.title}) : super(key: key);
  @override
  _CreacionViajeFormState createState() => _CreacionViajeFormState();

  final String title;
}

class _CreacionViajeFormState extends State<CreacionViajeForm> {
  final horaController = TextEditingController();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final fechaController = TextEditingController();
  final pesoController = TextEditingController();

  double peso = 0.0;

  DateTime choosenDate, choosenTime;

  // Ciudades origen y destino
  String origen, destino;

  final _formKey = GlobalKey<FormState>();

  void _add() {
    pesoController.text = (peso += 1).toString();
  }

  void _remove() {
    if (peso - 1 >= 0.0) pesoController.text = (peso -= 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text(TransportifyLabels.nuevoViaje),
              backgroundColor: TransportifyColors.primarySwatch,
              elevation: 0.0,
            ),
            backgroundColor: TransportifyColors.primarySwatch,
            body: Center(
              child: ListView(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                children: <Widget>[
                  /** 
                 * **************************
                 * SELECTOR DE PUNTO ORIGEN *
                 * **************************
                 * */
                  SizedBox(
                    height: 15.0,
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
                      String returnCiudad =
                          await CiudadDialog.show(this.context);

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
                  /** 
                 * ***************************
                 * SELECTOR DE PUNTO DESTINO *
                 * ***************************
                 * */
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    controller: destinoController,
                    decoration: TransportifyMethods.returnTextFormDecoration(
                        "Ciudad de destino"),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String returnCiudad =
                          await CiudadDialog.show(this.context);

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
                 * **************************
                 * SELECTOR DE CARGA MÁXIMA *
                 * **************************
                 * */
                  Row(
                    children: <Widget>[
                      Container(
                        width: 180,
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: TextStyle(
                              color: TransportifyColors.primarySwatch),
                          decoration:
                              TransportifyMethods.returnTextFormDecoration(
                                  "Carga Máxima (kg.)"),
                          onChanged: (text) {
                            peso = double.parse(text);
                          },
                          controller: pesoController,
                          validator: (value) {
                            if (value.isEmpty || double.parse(value) <= 0)
                              return 'Introduzca carga máxima.';
                            else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: RaisedButton(
                          color: TransportifyColors.primarySwatch[900],
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _add();
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: RaisedButton(
                          color: TransportifyColors.primarySwatch[900],
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _remove();
                          },
                        ),
                      ),
                    ],
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

                    //elevation: 4.0,
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
                        //print('confirm $date');
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
                        "Fecha comienzo del viaje"),
                    validator: (value) {
                      if (choosenTime == null) {
                        return 'Introduzca una fecha.';
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  /** 
                 * ******************
                 * SELECTOR DE HORA *
                 * ******************
                 * */
                  TextFormField(
                    maxLines: 1,
                    controller: horaController,
                    //elevation: 4.0,
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
                        "Hora de comienzo del viaje"),
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    validator: (value) {
                      if (choosenTime == null) {
                        return 'Introduzca una hora.';
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: new Stack(
              overflow: Overflow.visible,
              alignment: new FractionalOffset(5, 0.5),
              children: [
                new Container(
                    height: 80.0, color: TransportifyColors.primarySwatch),
                new Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: buildButtonContainer("ACEPTAR"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: buildButtonContainer("CANCELAR"),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ],
            )));
  }

  Viaje getViajeFromControllers() {
    double _peso = double.parse(pesoController.text);

    //print(_nombre);
    DateTime fechaViajeElegida = new DateTime(
        choosenDate.year,
        choosenDate.month,
        choosenDate.day,
        choosenTime.hour,
        choosenTime.minute,
        0);

    return new Viaje(
      cargaMaxima: _peso,
      fecha: fechaViajeElegida,
      destino: destino,
      origen: origen,
    );
  }

  Widget buildButtonContainer(String hintText) {
    return TransportifyFormButton(
      text: hintText,
      onPressed: () {
        if (hintText == "ACEPTAR") {
          if (_formKey.currentState.validate()) {
            Viaje viaje = getViajeFromControllers();
            viaje.crearEnBD();
            Usuario usuarioActual = DatosUsuarioActual.instance.usuario;
            usuarioActual?.viajesCreados++;
            usuarioActual?.updateBD();
            TransportifyMethods.doneDialog(context, "Viaje creado",
                content: "El viaje ha sido creado con éxito");
          }
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
