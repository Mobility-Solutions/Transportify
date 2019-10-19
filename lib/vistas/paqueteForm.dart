import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/util/style.dart';

class PaqueteForm extends StatefulWidget {
  static const String tag = 'paquete-form';
  static const String title = 'Nuevo Paquete';
  static PuntoTransportify puntoOrigen, puntoDestino;

  @override
  _PaqueteFormState createState() => _PaqueteFormState();
}

class _PaqueteFormState extends State<PaqueteForm> {
  final pesoController = TextEditingController();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();

  var peso = 0.0;

  Future<Null> getTransportifyPoint(bool origen) async {
    PuntoTransportify returnPunto = await showDialog(
        context: this.context,
        builder: (_) {
          return PuntosDialog();
        });
    if (origen) {
      PaqueteForm.puntoOrigen = returnPunto;
      origenController.text = returnPunto.nombre;
    } else if (!origen) {
      PaqueteForm.puntoDestino = returnPunto;
      destinoController.text = returnPunto.nombre;
    }
  }

  void add() {
    pesoController.text = (peso += 1).toString();
  }

  void remove() {
    if (peso - 1 >= 0.0) pesoController.text = (peso -= 1).toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(PaqueteForm.title),
        backgroundColor: TransportifyColors.primarySwatch,
        elevation: 0.0,
      ),
      backgroundColor: TransportifyColors.primarySwatch,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          children: <Widget>[
            SizedBox(height: 5.0),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              style: TextStyle(color: TransportifyColors.primarySwatch),
              decoration: returnInputDecoration("Nombre"),
            ),

            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    decoration: returnInputDecoration("Peso"),
                    onChanged: (text) {
                      peso = double.parse(text);
                    },
                    controller: pesoController,
                  ),
                ),
                SizedBox(width: 10),
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
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                    child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  style: TextStyle(color: TransportifyColors.primarySwatch),
                  decoration: returnInputDecoration("Alto(cm)"),
                )),
                Flexible(
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    decoration: returnInputDecoration("Ancho(cm)"),
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    decoration: returnInputDecoration("Largo(cm)"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              style: TextStyle(color: TransportifyColors.primarySwatch),
              controller: origenController,
              decoration: returnInputDecoration("Punto Transportify de origen"),
              onTap: () {
                getTransportifyPoint(true);
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              style: TextStyle(color: TransportifyColors.primarySwatch),
              controller: destinoController,
              decoration:
                  returnInputDecoration("Punto Transportify de destino"),
              onTap: () {
                getTransportifyPoint(false);
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.datetime,
              autofocus: false,
              style: TextStyle(color: TransportifyColors.primarySwatch),
              decoration: returnInputDecoration(
                  "Fecha de entrega al punto Transportify"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: new Stack(
        overflow: Overflow.visible,
        alignment: new FractionalOffset(5, 0.5),
        children: [
          new Container(height: 80.0, color: TransportifyColors.primarySwatch),
          new Row(
            children: <Widget>[
              Expanded(
                child: buildButtonContainer("ACEPTAR"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: buildButtonContainer("CANCELAR"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButtonContainer(String hintText) {
    return GestureDetector(
        onTap: () {
          if (hintText == "ACEPTAR") {

          } else {}
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
