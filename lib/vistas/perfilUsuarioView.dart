import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/Keys.dart';
import 'package:transportify/util/style.dart';

import '../modelos/Usuario.dart';
import 'Authentication/iniciarSesion/iniciarSesion.dart';
import 'CiudadDialog.dart';

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

  var nombreApellidosText = TextEditingController();
  var correoText = TextEditingController();
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
              key: Key(Keys.editButton),
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
            padding: EdgeInsets.only(left:15.0, right: 15.0, bottom: 30.0, top: 15.0),
            child: Container (
              child: SingleChildScrollView(
                child: Column(
                children: <Widget> [

                  SizedBox(
                  height: 20.0,
                  ),

                    TextFormField(
                    key: Key(Keys.inputNombre),
                    controller: nombreApellidosText,
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
                    key: Key(Keys.inputCorreo),
                    controller: correoText,
                    enabled: editable,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    maxLength: 50,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El valor no puede estar vacío';
                      }
                      if (!_isEmailCorrectlyFormed(value)) {
                        return 'El formato es invalido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail_outline),
                      hintText: 'Introduce tu correo',
                      labelText: 'CORREO',
                    ),
                  ),

                  SizedBox(
                  height: 20.0,
                  ),

                  TextFormField(
                    key: Key(Keys.inputCiudad),
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
                    key: Key(Keys.inputEdad),
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
                      if(soloNumeros < 18 || soloNumeros > 99) {
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
                        key: Key(Keys.saveButton),
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
                          setState(() {
                            if(_formKey.currentState.validate()) {
                              if(editable) {
                                cambiarColorEditable();
                                guardarCambios();
                                editable = false;
                              }
                            }
                          }
                        );
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
                          }
                        );
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
    if(editable) {
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
                
                Navigator.of(context)
                .pushReplacement(MaterialPageRoute<Null>(builder: (BuildContext context) {
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
    widget.usuario.nombre = nombreApellidosText.text;
    widget.usuario.correo = correoText.text;
    widget.usuario.ciudad = ciudadText.text;
    widget.usuario.edad = int.parse(edadText.text);
    widget.usuario.updateBD();
  }

  bool _isEmailCorrectlyFormed(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    nombreApellidosText.text = widget.usuario.nombre;
    correoText.text = widget.usuario.correo;
    ciudadText.text = widget.usuario.ciudad;
    edadText.text = widget.usuario.edad.toString();
  }

  @override
  void dispose() {
    nombreApellidosText.dispose();
    correoText.dispose();
    ciudadText.dispose();
    edadText.dispose();
    super.dispose();
  }
  
}