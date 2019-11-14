import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/util/style.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


import '../PuntosDialog.dart';

class CreacionPaqueteForm extends StatefulWidget {
  CreacionPaqueteForm([this.miPaquete]) : super();

  final Paquete miPaquete;

  @override
  _CreacionPaqueteFormState createState() => _CreacionPaqueteFormState();
}

class _CreacionPaqueteFormState extends State<CreacionPaqueteForm> {

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
    if(widget.miPaquete == null) {
      pesoController.text = (peso += 1).toString();
    } else {
      pesoController.text = (widget.miPaquete.peso += 1).toString();
    }
  }

  void _remove() {
    if(widget.miPaquete == null) {
      if (peso - 1 >= 0.0) pesoController.text = (peso -= 1).toString();
    } else {
      if (widget.miPaquete.peso - 1 >= 0.0) pesoController.text = (widget.miPaquete.peso -= 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: (widget.miPaquete == null) ? Text(TransportifyLabels.nuevoPaquete) : Text("Modificar paquete"),
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
                    (widget.miPaquete == null) ? TransportifyMethods.returnTextFormDecoration("Nombre") : TransportifyMethods.returnTextFormDecoration(widget.miPaquete.nombre),
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
                          (widget.miPaquete == null) ? TransportifyMethods.returnTextFormDecoration("Peso(kg)") : TransportifyMethods.returnTextFormDecoration(widget.miPaquete.peso.toString()),
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
                    decoration: (widget.miPaquete == null) ? TransportifyMethods.returnTextFormDecoration(
                        "Alto(cm)") : TransportifyMethods.returnTextFormDecoration(widget.miPaquete.alto.toString()),
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
                      decoration: (widget.miPaquete == null) ? TransportifyMethods.returnTextFormDecoration(
                          "Ancho(cm)") : TransportifyMethods.returnTextFormDecoration(widget.miPaquete.ancho.toString()),
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
                      decoration: (widget.miPaquete == null) ? TransportifyMethods.returnTextFormDecoration(
                          "Largo(cm)") : TransportifyMethods.returnTextFormDecoration(widget.miPaquete.largo.toString()) ,
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
                decoration: (widget.miPaquete == null) ? TransportifyMethods.returnTextFormDecoration(
                    "Punto Transportify de origen") : TransportifyMethods.returnTextFormDecoration(widget.miPaquete.origen.toString()),
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
                decoration: (widget.miPaquete == null) ? TransportifyMethods.returnTextFormDecoration(
                    "Punto Transportify de destino") : TransportifyMethods.returnTextFormDecoration(widget.miPaquete.destino.toString()),
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
        origen: puntos.origen,
        destino: puntos.destino,
        fechaEntrega: _fechaentrega);
  }

  @override
  void initState() {
    super.initState();
    if(widget.miPaquete != null) {
    nombreController.text = widget.miPaquete.nombre;
    pesoController.text = widget.miPaquete.peso.toString();
    origenController.text = widget.miPaquete.origen.toString();
    destinoController.text = widget.miPaquete.destino.toString();
    fechaController.text = widget.miPaquete.fechaEntrega.toString();
    altoController.text = widget.miPaquete.alto.toString();
    anchoController.text = widget.miPaquete.ancho.toString();
    largoController.text = widget.miPaquete.largo.toString();
    _fragil = widget.miPaquete.fragil;
    }
  }

  @override
  void dispose() {
    if(widget.miPaquete != null) {
    nombreController.dispose();
    pesoController.dispose();
    origenController.dispose();
    destinoController.dispose();
    fechaController.dispose();
    altoController.dispose();
    anchoController.dispose();
    largoController.dispose();
    super.dispose();
    }
  }

  Widget buildButtonContainer(String hintText) {
    return TransportifyFormButton(
      text: hintText,
      onPressed: () {

        if (hintText == "ACEPTAR" && widget.miPaquete == null) {
          
          if (_formKey.currentState.validate()) {

            Paquete paquete = getPaqueteFromControllers();
            paquete.crearEnBD();
            TransportifyMethods.doneDialog(context, "Paquete creado",
                content: "El paquete ha sido creado con éxito");

          }

        } else if(hintText == "ACEPTAR" && widget.miPaquete != null) {

          if (_formKey.currentState.validate()) {

            widget.miPaquete.alto = double.parse(altoController.text);
            widget.miPaquete.ancho = double.parse(anchoController.text);
            widget.miPaquete.largo = double.parse(largoController.text);
            widget.miPaquete.peso = double.parse(pesoController.text);
            widget.miPaquete.origen = puntos.origen;
            widget.miPaquete.destino = puntos.destino;
            widget.miPaquete.nombre = nombreController.text;
            widget.miPaquete.fragil = _fragil;
            widget.miPaquete.fechaEntrega = _fechaentrega;

            widget.miPaquete.updateBD();
            TransportifyMethods.doneDialog(context, "Paquete modificado",
                  content: "El paquete ha sido modificado con éxito");

          }
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
