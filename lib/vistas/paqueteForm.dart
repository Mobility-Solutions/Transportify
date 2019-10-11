import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';

class PaqueteForm extends StatelessWidget {
  static String tag = 'paquete-form';
  static const String title = 'Nuevo Paquete';

  @override
  Widget build(BuildContext context) {

    final nombrePaquete = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(color: TransportifyColors.primarySwatch),
      decoration: InputDecoration(
        hintText: 'Nombre del paquete',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
        backgroundColor: TransportifyColors.primarySwatch,
        elevation: 0.0,
      ),
      backgroundColor: TransportifyColors.primarySwatch,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 48.0),
            nombrePaquete,
            SizedBox(height: 8.0),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
  }