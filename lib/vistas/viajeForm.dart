import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:transportify/middleware/ViajeTransportifyBD.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/util/style.dart';

import '../modelos/Viaje.dart';



class MyViajeForm extends StatefulWidget {
  
  MyViajeForm({Key key, this.title}) : super(key: key);
  @override
  _MyViajeFormState createState() => _MyViajeFormState();

  final String title;
}

class _MyViajeFormState extends State<MyViajeForm> {

  final horaController = TextEditingController();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  final fechaController = TextEditingController();
  final pesoController = TextEditingController();

  double peso = 0.0;

  DateTime choosenDate;
  DateTime choosenTime;




  PuntoTransportify puntoOrigen, puntoDestino;


  final _formKey = GlobalKey<FormState>();


Future<Null> getTransportifyPoint(bool origen) async {
    PuntoTransportify returnPunto = await showDialog(
        context: this.context,
        builder: (_) {
          return PuntosDialog();
        });
    if (returnPunto != null) {
      if (origen) {
        puntoOrigen = returnPunto;
        origenController.text = puntoOrigen?.nombre;
      } else if (!origen) {
        puntoDestino = returnPunto;
        destinoController.text = puntoDestino?.nombre;
      }
    }
  }


  InputDecoration returnInputDecoration(String hintText) {
    return InputDecoration(
      suffixIcon: hintText.startsWith("Punto") ? Icon(Icons.location_on) : null,
      hintText: hintText,
      hintStyle: TextStyle(color: TransportifyColors.primarySwatch),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      );
    }

  void add() {
    pesoController.text = (peso += 1).toString();
  }

  void remove() {
    if (peso - 1 >= 0.0) pesoController.text = (peso -= 1).toString();
  }

  @override 
   Widget build(BuildContext context) {
    
    

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Publicar un Viaje"),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0
        ),
        backgroundColor: TransportifyColors.primarySwatch,
        body: Padding(
          padding: EdgeInsets.only(left:15.0, right: 15.0),
          child: Container (
            child: Column(
              
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
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
                  decoration:
                      returnInputDecoration("Punto Transportify de origen"),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    getTransportifyPoint(true);
                  },
                  validator: (value) {
                    if (puntoOrigen == null || puntoDestino == null)
                      return 'Introduzca los puntos origen';
                    else if (puntoDestino.id == puntoOrigen.id)
                      return 'Los puntos no deben coincidir.';
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
                  decoration:
                      returnInputDecoration("Punto Transportify de destino"),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    getTransportifyPoint(false);
                  },
                  validator: (value) {
                    if (puntoOrigen == null || puntoDestino == null)
                      return 'Introduzca los puntos origen y destino';
                    else if (puntoDestino.id == puntoOrigen.id)
                      return 'Los puntos no deben coincidir.';
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
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style: TextStyle(color: TransportifyColors.primarySwatch),
                      decoration: returnInputDecoration("Peso"),
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
                        add();
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
                        remove();
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
                    DatePicker.showDatePicker(
                      context,
                        theme: DatePickerTheme(
                          containerHeight: 200.0,
                        ),
                        minTime: new DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 1),
                        maxTime: new DateTime(DateTime.now().year + 3),
                        showTitleActions: true,
                        onConfirm: (date) {
                      //print('confirm $date');
                      choosenDate = date;
                      String _date = '${date.day} / ${date.month} / ${date.year}';
                      setState(() {
                        fechaController.text = _date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  keyboardType: TextInputType.datetime,
                  autofocus: false,
                  style: TextStyle(color: TransportifyColors.primarySwatch),
                  decoration: returnInputDecoration(
                    "Fecha comienzo del viaje"
                  ),
                  validator: (value) {
                    if(choosenTime == null) {
                      return 'Introduzca una fecha.';
                    } else return null;

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
                    DatePicker.showTimePicker(
                      context,
                        theme: DatePickerTheme(
                          containerHeight: 200.0,
                        ),
                        showTitleActions: true,
                        onConfirm: (time) {
                      print('confirm $time');
                      choosenTime = time;
                      String _time = '${time.hour} : ${time.minute}';
                      setState(() {
                        horaController.text = _time;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  decoration: returnInputDecoration(
                    "Hora de comienzo del viaje"
                  ),
                  autofocus: false,
                  style: TextStyle(color: TransportifyColors.primarySwatch),
                  validator: (value) {
                    if(choosenTime == null) {
                      return 'Introduzca una hora.';
                    } else return null;

                  },
                ),
                SizedBox(
                  height: 100.0,
                ),
              ],
            ),
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
        )
      )
    );
  }

  Viaje getViajeFromControllers() {
    double _peso = double.parse(pesoController.text);
    
    //print(_nombre);
    DateTime fechaViajeElegida = new DateTime(choosenDate.year, choosenDate.month, choosenDate.day, choosenTime.hour, choosenTime.minute, 0);

    return new Viaje(
        cargaMaxima: _peso,
        fecha: fechaViajeElegida,
        destinoId: puntoDestino.id,
        origenId: puntoOrigen.id,

);
  }

  Widget buildButtonContainer(String hintText) {
    return GestureDetector(
        onTap: () {
          if (hintText == "ACEPTAR") {
            if (_formKey.currentState.validate()) {
              Viaje viaje = getViajeFromControllers();
              ViajeTransportifyBD.crearViajeEnBD(viaje);
              doneDialog();
            }
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          height: 56.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: TransportifyColors.primarySwatch[900]),
          child: Center(
            child: Text(
              hintText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ));
  }

  doneDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Viaje creado"),
        content: Text("El viaje ha sido creado con éxito."),
        actions: [
          new FlatButton(
            child: new Text("CERRAR"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    Navigator.pop(context);
  }

}

class PuntosDialog extends StatefulWidget {
  @override
  _PuntosDialogState createState() => new _PuntosDialogState();
}

class _PuntosDialogState extends State<PuntosDialog> {
  String _ciudadSeleccionada;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Puntos Transportify"),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: PuntoTransportifyBD.obtenerDropDownCiudadesYListadoPuntos(
                onPuntoChanged: (nuevoPunto) {
                  Navigator.pop(context, nuevoPunto);
                },
                onCiudadChanged: (nuevaCiudad) {
                  setState(() {
                    this._ciudadSeleccionada = nuevaCiudad;
                  });
                },
                ciudadValue: _ciudadSeleccionada,
              ),
            )));
  }
}

  
