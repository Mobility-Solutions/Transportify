import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/inicio/Authentication/iniciarSesion/iniciarSesion.dart';
import 'package:transportify/vistas/dialog/CiudadDialog.dart';

class PerfilUsuarioView extends StatefulWidget {
  @override
  PerfilUsuarioViewState createState() => PerfilUsuarioViewState();

  PerfilUsuarioView(this.usuario) : super();

  final Usuario usuario;
}

class PerfilUsuarioViewState extends State<PerfilUsuarioView> {
  final _formKey = GlobalKey<FormState>();

  bool editable = false;

  Color colorEditar = Colors.grey;
  Color colorGuardarCambios = Colors.grey;
  Color colorInternoGuardarCambios = Colors.grey;

  String ciudad;

  var nombreText = TextEditingController();
  var nicknameText = TextEditingController();
  var ciudadText = TextEditingController();
  var edadText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mi perfil"),
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
                  TextFormField(
                    controller: nombreText,
                    enabled: editable,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    maxLength: 50,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El valor no puede estar vacío';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Introduce tu nombre y apellidos',
                      labelText: 'NOMBRE Y APELLIDOS',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: nicknameText,
                    enabled: editable,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    maxLength: 50,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El valor no puede estar vacío';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_outline),
                      hintText: 'Introduce tu nombre de usuario',
                      labelText: 'USUARIO',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: ciudadText,
                    enabled: editable,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String returnCiudad =
                          await CiudadDialog.show(this.context);

                      if (returnCiudad != null) {
                        ciudad = returnCiudad;
                        ciudadText.text = ciudad;
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El valor no puede estar vacío';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_city),
                      hintText: 'Introduce tu ciudad',
                      labelText: 'CIUDAD',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: edadText,
                    enabled: editable,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    maxLength: 2,
                    validator: (value) {
                      final soloNumeros = int.tryParse(value);
                      if (soloNumeros == null) {
                        return 'El valor no puede estar vacío';
                      }
                      if (soloNumeros < 18 || soloNumeros > 99) {
                        return 'Edad incorrecta';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.date_range),
                      hintText: 'Introduce tu edad',
                      labelText: 'EDAD',
                    ),
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
                          setState(() async {
                            if (_formKey.currentState.validate()) {
                              if (await UsuarioBD.existeUsuarioConNickname(
                                  nicknameText.text)) {
                                Toast.show(
                                    "Error: El nombre de usuario está en uso. Elija otro.",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } else if (editable) {
                                cambiarColorEditable();
                                guardarCambios();
                                editable = false;
                              }
                            }
                          });
                        },
                        child: Text(
                          "Guardar cambios",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        onPressed: () {
                          setState(() {
                            showDialogBorrarPerfil();
                          });
                        },
                        child: Text(
                          "Borrar perfil",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
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

  void showDialogBorrarPerfil() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("¿Estas seguro que quieres borrar tu perfil?"),
          content: new Text("Esto borrará tu perfil de forma permanente"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          actions: <Widget>[
            new FlatButton(
              color: TransportifyColors.primarySwatch,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
                print("Perfil eliminado");
                widget.usuario.deleteFromBD();

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new IniciarSesionView();
                }));

                /*
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => IniciarSesionView()),
                (Route<dynamic> route) => false,
                );
                */
              },
            ),
            new FlatButton(
              color: TransportifyColors.primarySwatch,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void guardarCambios() {
    widget.usuario.nombre = nombreText.text;
    widget.usuario.nickname = nicknameText.text;
    widget.usuario.ciudad = ciudadText.text;
    widget.usuario.edad = int.parse(edadText.text);
    widget.usuario.updateBD();

    Toast.show("Los datos han sido actualizados", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    nombreText.text = widget.usuario.nombre;
    nicknameText.text = widget.usuario.nickname;
    ciudadText.text = widget.usuario.ciudad;
    edadText.text = widget.usuario.edad.toString();
  }

  @override
  void dispose() {
    nombreText.dispose();
    nicknameText.dispose();
    ciudadText.dispose();
    edadText.dispose();
    super.dispose();
  }
}
