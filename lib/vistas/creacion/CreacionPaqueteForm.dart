import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/util/style.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:transportify/vistas/MapaView.dart';
import 'package:transportify/vistas/dialog/PuntosDialog.dart';

class CreacionPaqueteForm extends StatefulWidget {
  CreacionPaqueteForm({this.miPaquete, this.usuario}) : super();
  @override
  _CreacionPaqueteFormState createState() => _CreacionPaqueteFormState();

  final Paquete miPaquete;
  final Usuario usuario;
}

class _CreacionPaqueteFormState extends State<CreacionPaqueteForm> {
  final nombreController = TextEditingController();
  final pesoController = TextEditingController();
  final precioController = TextEditingController();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final fechaController = TextEditingController();
  final altoController = TextEditingController();
  final anchoController = TextEditingController();
  final largoController = TextEditingController();
  final horaController = TextEditingController();

  double peso = 0.0;
  double precio = 0.0;
  bool _fragil = false;
  double alto = 0.0;
  double ancho = 0.0;
  double largo = 0.0;
  double _sliderValue = 0.0;
  double diasMargen = 0.0;

  final Puntos puntos = Puntos();

  DateTime _fechaentrega;
  DateTime _horaEntrega;

  bool get modificando => widget.miPaquete != null;

  final _formKey = GlobalKey<FormState>();

  void _addPeso() {
    pesoController.text = (peso += 1).toString();
  }

  void _removePeso() {
    if (peso - 1 >= 0.0) pesoController.text = (peso -= 1).toString();
  }

  void _addPrecio() {
    precioController.text = (precio += 1).toString();
  }

  void _removePrecio() {
    if (precio - 1 >= 0.0) precioController.text = (precio -= 1).toString();
  }

  getPuntoSeleccionado(BuildContext context, bool origenLocation) async {
    PuntoTransportify puntoInicial =
        origenLocation ? puntos.origen : puntos.destino;
        
    final PuntoTransportify puntoSeleccionado =
        await Navigator.of(context).push<PuntoTransportify>(MaterialPageRoute(
            builder: (context) => MapaViewPuntos(
                  usuario: widget.usuario,
                  puntoInicial: puntoInicial,
                )));

    if (origenLocation) {
      if (puntoSeleccionado != null) {
        puntos.origen = puntoSeleccionado;
        origenController.text = puntos.origen?.nombre;
      }
    } else {
      if (puntoSeleccionado != null) {
        puntos.destino = puntoSeleccionado;
        destinoController.text = puntos.destino?.direccion;
      }
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
          title: (widget.miPaquete == null)
              ? Text(TransportifyLabels.nuevoPaquete)
              : Text("Modificar paquete"),
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
                      decoration: TransportifyMethods.returnTextFormDecoration(
                          "Peso(kg)"),
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
                        _addPeso();
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
                        _removePeso();
                      },
                    ),
                  ),
                ],
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
                      decoration: TransportifyMethods.returnTextFormDecoration(
                          "Precio(€)"),
                      onChanged: (text) {
                        precio = double.parse(text);
                      },
                      controller: precioController,
                      validator: (value) {
                        if (value.isEmpty || double.parse(value) <= 0)
                          return 'Precio incorrecto';
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
                        _addPrecio();
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
                        _removePrecio();
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: TextStyle(color: TransportifyColors.primarySwatch),
                      controller: origenController,
                      decoration: TransportifyMethods.returnTextFormDecoration(
                          "Punto Transportify de origen"),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        PuntoTransportify returnPunto = await PuntosDialog.show(
                            this.context,
                            ciudadInicial: widget.usuario?.ciudad,
                            puntoInicial: puntos.origen);

                        if (returnPunto != null) {
                          puntos.origen = returnPunto;
                          origenController.text = puntos.origen?.nombre;
                        }
                      },
                      validator: (value) => puntos.validate(),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  IconButton(
                    color: TransportifyColors.primarySwatch,
                    icon: Icon(Icons.map, color: Colors.white),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      getPuntoSeleccionado(context, true);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      style: TextStyle(color: TransportifyColors.primarySwatch),
                      controller: destinoController,
                      decoration: TransportifyMethods.returnTextFormDecoration(
                          "Punto Transportify de destino"),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        PuntoTransportify returnPunto = await PuntosDialog.show(
                            this.context,
                            puntoInicial: puntos
                                ?.destino); // Ciudad inicial del usuario solo en origen

                        if (returnPunto != null) {
                          puntos.destino = returnPunto;
                          destinoController.text = puntos.destino?.nombre;
                        }
                      },
                      validator: (value) => puntos.validate(),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  IconButton(
                    color: TransportifyColors.primarySwatch,
                    icon: Icon(Icons.map, color: Colors.white),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      getPuntoSeleccionado(context, false);
                    },
                  ),
                ],
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
              SizedBox(height: 20.0),
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
                    _horaEntrega = time;
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
                  if (_horaEntrega == null) {
                    return 'Introduzca una hora.';
                  } else
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
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Slider(
                      activeColor: TransportifyColors.primarySwatch[900],
                      divisions: 7,
                      //label: _sliderValue.toString(),
                      min: 0.0,
                      max: 7.0,
                      onChanged: (newRating) {
                        setState(() => _sliderValue = newRating);
                        diasMargen = _sliderValue;
                      },
                      value: _sliderValue),
                  Container(
                    width: 130.0,
                    alignment: Alignment.center,
                    child: Text(
                      '${_sliderValue.toInt()} días de margen',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: new Stack(
          overflow: Overflow.visible,
          alignment: new FractionalOffset(5, 0.5),
          children: [
            new Container(
                height: 70.0, color: TransportifyColors.primarySwatch),
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: buildButtonContainer("CANCELAR"),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: buildButtonContainer("ACEPTAR"),
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

  Future<Paquete> getPaqueteFromControllers() async {
    double _alto = double.parse(altoController.text);
    double _ancho = double.parse(anchoController.text);
    double _largo = double.parse(largoController.text);
    double _peso = double.parse(pesoController.text);
    double _precio = double.parse(precioController.text);
    int diasMargenFinal = diasMargen.toInt();
    String _nombre = nombreController.text;
    DateTime fechaPaqueteElegida = new DateTime(
        _fechaentrega.year,
        _fechaentrega.month,
        _fechaentrega.day,
        _horaEntrega.hour,
        _horaEntrega.minute,
        0);

    print(_nombre);

    return Paquete(
      nombre: _nombre,
      alto: _alto,
      ancho: _ancho,
      largo: _largo,
      peso: _peso,
      precio: _precio,
      fragil: _fragil,
      origen: puntos.origen,
      destino: puntos.destino,
      fechaEntrega: fechaPaqueteElegida,
      diasMargen: diasMargenFinal,
      remitente: await UsuarioBD.obtenerUsuarioActual(),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.miPaquete != null) {
      nombreController.text = widget.miPaquete.nombre;
      pesoController.text = widget.miPaquete.peso.toString();
      precioController.text = widget.miPaquete.precio.toString();
      peso = widget.miPaquete.peso;
      precio = widget.miPaquete.precio;
      puntos.origen = widget.miPaquete.origen;
      puntos.destino = widget.miPaquete.destino;
      if (widget.miPaquete.origen != null) {
        origenController.text = widget.miPaquete.origen.nombre.toString();
      } else {
        origenController.text = "Sin punto seleccionado";
      }

      if (widget.miPaquete.destino != null) {
        destinoController.text = widget.miPaquete.destino.nombre.toString();
      } else {
        destinoController.text = "Sin punto seleccionado";
      }

      fechaController.text =
          '${widget.miPaquete.fechaEntrega.day} / ${widget.miPaquete.fechaEntrega.month} / ${widget.miPaquete.fechaEntrega.year}';
      DateTime fechaModificando = new DateTime(
          widget.miPaquete.fechaEntrega.year,
          widget.miPaquete.fechaEntrega.month,
          widget.miPaquete.fechaEntrega.day);
      _fechaentrega = fechaModificando;
      DateTime horaModificando = new DateTime(
          0,
          0,
          0,
          widget.miPaquete.fechaEntrega.hour,
          widget.miPaquete.fechaEntrega.minute);
      _horaEntrega = horaModificando;
      horaController.text = '${_horaEntrega.hour}:${_horaEntrega.minute}';
      altoController.text = widget.miPaquete.alto.toString();
      anchoController.text = widget.miPaquete.ancho.toString();
      largoController.text = widget.miPaquete.largo.toString();
      _fragil = widget.miPaquete.fragil;
      if (widget.miPaquete.diasMargen != null) {
        diasMargen = widget.miPaquete.diasMargen.toDouble();
        _sliderValue = widget.miPaquete.diasMargen.toDouble();
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    pesoController.dispose();
    precioController.dispose();
    origenController.dispose();
    destinoController.dispose();
    fechaController.dispose();
    horaController.dispose();
    altoController.dispose();
    anchoController.dispose();
    largoController.dispose();

    super.dispose();
  }

  Widget buildButtonContainer(String hintText) {
    return TransportifyFormButton(
      text: hintText,
      onPressed: () async {
        if (hintText == "ACEPTAR" && !modificando) {
          if (_formKey.currentState.validate()) {
            Paquete paquete = await getPaqueteFromControllers();
            paquete.crearEnBD();
            Usuario remitente = paquete.remitente;
            remitente?.paquetesCreados++;
            remitente?.updateBD();
            TransportifyMethods.doneDialog(context, "Paquete creado",
                content: "El paquete ha sido creado con éxito");
          }
        } else if (hintText == "ACEPTAR" && modificando) {
          if (_formKey.currentState.validate()) {
            widget.miPaquete.alto = double.parse(altoController.text);
            widget.miPaquete.ancho = double.parse(anchoController.text);
            widget.miPaquete.largo = double.parse(largoController.text);
            widget.miPaquete.peso = double.parse(pesoController.text);
            widget.miPaquete.precio = double.parse(precioController.text);
            widget.miPaquete.origen = puntos.origen;
            widget.miPaquete.destino = puntos.destino;
            widget.miPaquete.nombre = nombreController.text;
            widget.miPaquete.fragil = _fragil;
            DateTime fechaEntregaDefinitiva = new DateTime(
                _fechaentrega.year,
                _fechaentrega.month,
                _fechaentrega.day,
                _horaEntrega.hour,
                _horaEntrega.minute);
            widget.miPaquete.fechaEntrega = fechaEntregaDefinitiva;
            widget.miPaquete.diasMargen = _sliderValue.toInt();

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
