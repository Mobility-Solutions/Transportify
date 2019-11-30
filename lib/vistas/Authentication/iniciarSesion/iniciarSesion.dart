import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/Authentication/registrarse/registrarse.dart';
import 'EmailAndPassword.dart';

class IniciarSesionView extends StatefulWidget {
  final String title = 'Iniciar sesión';
  final VoidCallback loginCallback;
  
  IniciarSesionView({this.loginCallback});

  @override
  _IniciarSesionViewState createState() => new _IniciarSesionViewState();
}

class _IniciarSesionViewState extends State<IniciarSesionView> {

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Estás seguro?'),
            content: new Text('¿Quieres salir de la aplicación?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Sí'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            leading: new Container(
              child: SizedBox(),
            ),
            title: Text(widget.title),
            backgroundColor: TransportifyColors.primarySwatch,
          ),
          body: Padding(
              padding: EdgeInsets.all(10.0),
              child: Builder(builder: (BuildContext context) {
                return ListView(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.directions_car,
                        color: TransportifyColors.primarySwatch,
                        size: 120,
                      ),
                    ),
                    EmailPasswordForm(loginCallback:widget.loginCallback),
                    //GoogleSignInSection(),
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
        ));
  }

  void abrirRegistrarse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registrarse()),
    );
  }
}
