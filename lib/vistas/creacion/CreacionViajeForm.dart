import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/dialog/CiudadDialog.dart';

class CreacionViajeForm extends StatefulWidget {
  CreacionViajeForm({this.viajeModificando, Key key, this.title, this.usuario})
      : super(key: key);
  @override
  _CreacionViajeFormState createState() => _CreacionViajeFormState();

  final String title;
  final Viaje viajeModificando;
  final Usuario usuario;
}

class _CreacionViajeFormState extends State<CreacionViajeForm> {
  final horaController = TextEditingController();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final fechaController = TextEditingController();
  final pesoController = TextEditingController();

  double peso = 0.0;

  DateTime choosenDate;
  DateTime choosenTime;

  bool get modificando => widget.viajeModificando != null;

  //final Puntos puntos = Puntos();

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
    Form view = new Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: (modificando)
                  ? Text("Modificar Viaje")
                  : Text(TransportifyLabels.nuevoViaje),
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
                          await CiudadDialog.show(this.context, ciudadInicial: origen ?? widget.usuario?.ciudad);

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
                          await CiudadDialog.show(this.context, ciudadInicial: destino); // Ciudad inicial del usuario solo en origen

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
    return view;
  }

  /// Si viajeModificando estaba inicializado lo actualiza con las modificaciones de la view
  /// y lo devuelve. Si no estaba inicializado, lo inicializa y hace lo mismo.
  Future<Viaje> getViajeFromControllers() async {
    Viaje viaje = modificando
        ? widget.viajeModificando
        : new Viaje(transportista: await UsuarioBD.obtenerUsuarioActual());

    viaje.cargaMaxima = double.parse(pesoController.text);

    DateTime fechaViajeElegida = new DateTime(
        choosenDate.year,
        choosenDate.month,
        choosenDate.day,
        choosenTime.hour,
        choosenTime.minute,
        0);

    viaje.fecha = fechaViajeElegida;

    viaje.destino = destino;

    viaje.origen = origen;

    return viaje;
  }

  @override
  void initState() {
    super.initState();
    if (widget.viajeModificando != null) {
      pesoController.text = widget.viajeModificando.cargaMaxima.toString();
      peso = widget.viajeModificando.cargaMaxima;

      origenController.text = widget.viajeModificando.origen;
      origen = widget.viajeModificando.origen;

      destinoController.text = widget.viajeModificando.destino;
      destino = widget.viajeModificando.destino;

      fechaController.text =
          '${widget.viajeModificando.fecha.day} / ${widget.viajeModificando.fecha.month} / ${widget.viajeModificando.fecha.year}';
      DateTime fechaModificando = new DateTime(
          widget.viajeModificando.fecha.year,
          widget.viajeModificando.fecha.month,
          widget.viajeModificando.fecha.day);
      choosenDate = fechaModificando;

      horaController.text =
          '${widget.viajeModificando.fecha.hour}:${widget.viajeModificando.fecha.minute}';
      DateTime horaModificando = new DateTime(
          0,
          0,
          0,
          widget.viajeModificando.fecha.hour,
          widget.viajeModificando.fecha.minute);
      choosenTime = horaModificando;
    }
  }

  @override
  void dispose() {
    if (modificando) {
      pesoController.dispose();
      origenController.dispose();
      destinoController.dispose();
      fechaController.dispose();
      origenController.dispose();
    }
    super.dispose();
  }

  Widget buildButtonContainer(String hintText) {
    return TransportifyFormButton(
      text: hintText,
      onPressed: () async {
        if (hintText == "ACEPTAR" && modificando) {
          if (_formKey.currentState.validate()) {
            Viaje viaje = await getViajeFromControllers();
            viaje.updateBD();

            TransportifyMethods.doneDialog(context, "Viaje modificado",
                content: "El viaje ha sido modificado con éxito");
          }
        } else if (hintText == "ACEPTAR" && !modificando) {
          if (_formKey.currentState.validate()) {
            Viaje viaje = await getViajeFromControllers();
            viaje.crearEnBD();
            Usuario transportista = viaje.transportista;
            transportista?.viajesCreados++;
            transportista?.updateBD();
            TransportifyMethods.doneDialog(context, "Viaje creado",
                content: "El viaje ha sido creado con éxito");
          }
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
/** 
  /// Este método se llama cuando recibimos un viaje en el constructor, indicando así que lo que
  /// se quiere es modificar un viaje existente (el que nos pasan) y no crear uno nuevo. Si se quiere crear
  /// uno nuevo viajeModificando será `null` y este método no se lanzará.
  ///
  /// Este método inicializa todos los campos del formulario a los valores del viaje que recibimos e 
  /// inicializa también las variables locales que se usan para luego crear o modificar el viaje.
  void inicializarCampos(Viaje viaje) {
    choosenTime = new DateTime(
        viaje.fecha.hour, viaje.fecha.minute);
    horaController.text = DateFormat.Hm().format(viaje.fecha);

    choosenDate = viaje.fecha;
    fechaController.text =
        '${viaje.fecha.day} / ${viaje.fecha.month} / ${viaje.fecha.year}';

    puntos.origen = viaje.origen;
    origenController.text = puntos.origen?.nombre;

    puntos.destino = viaje.destino;
    destinoController.text = puntos.destino?.nombre;

    peso = viaje.cargaMaxima;
    pesoController.text = viaje.cargaMaxima.toString();
  }
  */
}
