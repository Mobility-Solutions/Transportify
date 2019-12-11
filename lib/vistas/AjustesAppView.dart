import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:transportify/util/style.dart';

class AjustesAppView extends StatefulWidget {
  @override
  AjustesAppViewState createState() => AjustesAppViewState();

  AjustesAppView() : super();

}

class AjustesAppViewState extends State<AjustesAppView> {
  final _formKey = GlobalKey<FormState>();

  bool editable = false;
  bool notificaciones = true, usoDeGPS;

  Color colorEditar = Colors.grey;
  Color colorGuardarCambios = Colors.grey;
  Color colorInternoGuardarCambios = Colors.grey;

  String config;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajustes"),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              iconSize: 40,
              color: colorEditar,
              onPressed: () {
                setState(() {
                  cambiarColorEditable();
                  editable = !editable;
                });
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0, top: 15.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.notifications,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          Text("Notificaciones",
                            style: TextStyle(color: Colors.black, fontSize: 18.0),
                          )
                      ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Switch(
                            onChanged: (value) {
                              setState(() {
                                notificaciones = value;
                              });
                            },
                            value: notificaciones,
                          )
                        ]

                      ),
                      ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child:                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.announcement,
                          color: Colors.black,
                          size: 30.0,
                          ),
                          Text("Permisos internos",
                            style: TextStyle(color: Colors.black, fontSize: 18.0),
                          )
                        ]
                      ),
                     onPressed: () {},

                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: colorGuardarCambios,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        splashColor: colorInternoGuardarCambios,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        onPressed: () {
                          //setState(() async {
                            //  if (editable) {
                              //  cambiarColorEditable();
                              //  guardarCambios();
                              //  editable = false;
                            //  }
                            
                          //});
                        },
                        child: Text(
                          "Guardar",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void cambiarColorEditable() {
    if (editable) {
      colorEditar = Colors.grey;
      colorGuardarCambios = Colors.grey;
      colorInternoGuardarCambios = Colors.grey;
    } else {
      colorEditar = Colors.lightBlueAccent;
      colorGuardarCambios = TransportifyColors.primarySwatch;
      colorInternoGuardarCambios = Colors.blueAccent;
    }
  }

  void guardarCambios() {
    Toast.show("Los datos han sido actualizados", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    }

  @override
  void dispose() {
    super.dispose();
  }
}
