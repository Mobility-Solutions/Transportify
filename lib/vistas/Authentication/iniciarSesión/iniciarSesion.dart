import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/Authentication/registrarse/registrarse.dart';

import 'EmailAndPassword.dart';
import 'Google.dart';

class IniciarSesionView extends StatefulWidget {
  final String title = 'Iniciar sesion';

  @override
  _IniciarSesionViewState createState() => new _IniciarSesionViewState();
}

class _IniciarSesionViewState extends State<IniciarSesionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: TransportifyColors.primarySwatch,
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Builder(builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                EmailPasswordForm(),
                GoogleSignInSection(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: TransportifyColors.primarySwatch,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    onPressed: () async {
                      abrirRegistrarse();
                    },
                    child: Text(
                      "Registrarse",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                // _OtherProvidersSignInSection(),
              ],
            );
          })),
    );
  }

  void abrirRegistrarse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registrarse()),
    );
  }
}
