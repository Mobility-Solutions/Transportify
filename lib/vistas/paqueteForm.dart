import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';

class PaqueteForm extends StatelessWidget {
  static String tag = 'paquete-form';
  static const String title = 'Nuevo Paquete';

  @override
  Widget build(BuildContext context) {

    var txt = TextEditingController();
    var peso = 0;

    final nombrePaqueteText = TextFormField(
      maxLines: 1,
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

    final pesoPaqueteText = TextFormField(
      maxLines: 1,
      controller: txt,
      keyboardType: TextInputType.number,
      autofocus: false,
      style: TextStyle(color: TransportifyColors.primarySwatch),
      decoration: InputDecoration(
        hintText: 'Peso',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final dimensionesText = TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.number,
      autofocus: false,
      style: TextStyle(color: TransportifyColors.primarySwatch),
      decoration: InputDecoration(
        hintText: 'Dimensiones',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    void add(){
      txt.text = (peso+=1).toString();
    }
    void remove(){
      txt.text = (peso-=1).toString();
    }

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
            SizedBox(height: 10.0),
            nombrePaqueteText,
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: 
                  pesoPaqueteText),
                Expanded(
                  child: FlatButton(child: Icon(Icons.add, color: Colors.white,), onPressed: (){
                    add();
                  },
                  ),
                  ),
                Expanded(
                  child: FlatButton(child: Icon(Icons.remove, color: Colors.white,), onPressed: () {
                    remove();
                  },
                  ),
                  ),
              ],
            ),
            SizedBox(height: 10.0),
            dimensionesText,
          ],
        ),
      ),
    );
  }
  }