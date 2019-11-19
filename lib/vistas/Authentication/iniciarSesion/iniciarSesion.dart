import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/main.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/Authentication/registrarse/registrarse.dart';

import 'EmailAndPassword.dart';

class IniciarSesionMain extends StatelessWidget {
  static const String title = 'Transportify';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: IniciarSesionView(),
    );
  }
}

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
          //automaticallyImplyLeading: false,
          leading: new Container(child: SizedBox(),),
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
                  EmailPasswordForm(),
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
      );

  }

  void abrirRegistrarse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registrarse()),
    );
  }

  void checkUserIsLogged(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth.currentUser()!=null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }
}
