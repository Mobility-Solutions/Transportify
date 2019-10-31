import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/PaqueteTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/util/style.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../modelos/Paquete.dart';
import 'PuntosDialog.dart';

class PaqueteForm extends StatefulWidget {
  @override
  _PaqueteFormState createState() => _PaqueteFormState();
}

class _PaqueteFormState extends State<PaqueteForm> {
  final nombreController = TextEditingController();
  final pesoController = TextEditingController();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final fechaController = TextEditingController();
  final altoController = TextEditingController();
  final anchoController = TextEditingController();
  final largoController = TextEditingController();

  double peso = 0.0;
  bool _fragil = false;

  final Puntos puntos = Puntos();

  DateTime _fechaentrega;

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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(TransportifyLabels.nuevoPaquete),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
        backgroundColor: TransportifyColors.primarySwatch,
        body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                decoration:
                    TransportifyMethods.returnTextFormDecoration("Nombre"),
                controller: nombreController,
                validator: (value) {
                  if (value.isEmpty)
                    return 'Nombre';
                  else
                    return null;
                },
              ),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style: TextStyle(color: TransportifyColors.primarySwatch),
                      decoration:
                          TransportifyMethods.returnTextFormDecoration("Peso"),
                      onChanged: (text) {
                        peso = double.parse(text);
                      },
                      controller: pesoController,
                      validator: (value) {
                        if (value.isEmpty || double.parse(value) <= 0)
                          return 'Peso';
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
                        Icons.add,
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
                        Icons.remove,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _remove();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                      child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    decoration: TransportifyMethods.returnTextFormDecoration(
                        "Alto(cm)"),
                    controller: altoController,
                    validator: (value) {
                      if (value.isEmpty || double.parse(value) <= 0)
                        return 'Alto(cm)';
                      else
                        return null;
                    },
                  )),
                  Flexible(
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style: TextStyle(color: TransportifyColors.primarySwatch),
                      decoration: TransportifyMethods.returnTextFormDecoration(
                          "Ancho(cm)"),
                      controller: anchoController,
                      validator: (value) {
                        if (value.isEmpty || double.parse(value) <= 0)
                          return 'Ancho(cm)';
                        else
                          return null;
                      },
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style: TextStyle(color: TransportifyColors.primarySwatch),
                      decoration: TransportifyMethods.returnTextFormDecoration(
                          "Largo(cm)"),
                      controller: largoController,
                      validator: (value) {
                        if (value.isEmpty || double.parse(value) <= 0)
                          return 'Largo(cm)';
                        else
                          return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                controller: fechaController,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 200.0,
                      ),
                      showTitleActions: true,
                      minTime: new DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 1),
                      maxTime: new DateTime(DateTime.now().year + 3),
                      //onChanged: (date) {print ('change $date');},
                      onConfirm: (date) {
                    _fechaentrega = date;
                    String _date = '${date.day} - ${date.month} - ${date.year}';
                    setState(() {
                      fechaController.text = _date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                keyboardType: TextInputType.datetime,
                autofocus: false,
                style: TextStyle(color: TransportifyColors.primarySwatch),
                decoration: TransportifyMethods.returnTextFormDecoration(
                    "Fecha de entrega al punto Transportify"),
                validator: (value) {
                  if (value.isEmpty)
                    return 'Introduzca una fecha de entrega.';
                  else
                    return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    'Frágil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  )),
                  Flexible(
                    child: Checkbox(
                      value: _fragil,
                      checkColor: TransportifyColors.primarySwatch[900],
                      activeColor: Colors.white,
                      onChanged: (bool value) {
                        setState(() {
                          _fragil = value;
                        });
                      },
                    ),
                  ),
                ],
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
        ),
      ),
    );
  }

  Paquete getPaqueteFromControllers() {
    double _alto = double.parse(altoController.text);
    double _ancho = double.parse(anchoController.text);
    double _largo = double.parse(largoController.text);
    double _peso = double.parse(pesoController.text);
    String _nombre = nombreController.text;
    print(_nombre);

    return new Paquete(
        nombre: _nombre,
        alto: _alto,
        ancho: _ancho,
        largo: _largo,
        peso: _peso,
        fragil: _fragil,
        origenId: puntos.origen.id,
        destinoId: puntos.destino.id,
        fechaEntrega: _fechaentrega);
  }

  Widget buildButtonContainer(String hintText) {
    return TransportifyFormButton(
      text: hintText,
      onPressed: () {
        if (hintText == "ACEPTAR") {
          if (_formKey.currentState.validate()) {
            Paquete paquete = getPaqueteFromControllers();
            PaqueteTransportifyBD.crearPaqueteEnBD(paquete);
            TransportifyMethods.doneDialog(context, "Paquete creado",
                content: "El paquete ha sido creado con éxito");
          }
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
