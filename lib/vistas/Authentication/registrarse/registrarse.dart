import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/Authentication/Autenticacion.dart';

import '../../CiudadDialog.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Registrarse extends StatefulWidget {
  final String title = 'Registrarse';

  @override
  State<StatefulWidget> createState() => RegistrarseState();
}

class RegistrarseState extends State<Registrarse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _nameAndSurnameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _ciudad;
  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.directions_car,
                      color: TransportifyColors.primarySwatch,
                      size: 120,
                    ),
                  ),
                  TextFormField(
                    controller: _nicknameController,
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
                      hintText: 'Introduce nickname',
                      labelText: 'Nickname',
                    ),
                  ),
                  TextFormField(
                    controller: _nameAndSurnameController,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    maxLength: 50,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El valor no puede estar vacío';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Introduce tu nombre y apellidos',
                      labelText: 'Nombre y apellidos',
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
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
                      icon: Icon(Icons.mail_outline),
                      hintText: 'Introduce tu correo',
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    maxLines: 1,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    maxLength: 50,

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El valor no puede estar vacío';
                      }
                      if(value.length < 6){
                        return 'La contraseña debe tener mas de 6 carácteres';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Introduce contraseña',
                      labelText: 'Contraseña',
                    ),
                  ),
                  TextFormField(
                    controller: _cityController,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: false,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    maxLength: 50,
                      enableInteractiveSelection: false,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        String returnCiudad = await CiudadDialog.show(
                            this.context);

                        if (returnCiudad != null) {
                          _ciudad = returnCiudad;
                          _cityController.text = _ciudad;
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
                      labelText: 'Ciudad',
                    ),
                  ),
                  TextFormField(
                    controller: _ageController,
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
                      labelText: 'Edad',
                    ),
                  ),
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
                        if (_formKey.currentState.validate()) {
                          _register();
                        }
                      },
                      child: Text(
                        "Registrarse",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(_success == null
                        ? ''
                        : (_success
                            ? 'Successfully registered ' + _userEmail
                            : 'Registration failed')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      _addUserParameters(user.uid);
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      Autenticacion.userSignInIncorrectly();
      _success = false;
    }
  }

  void _addUserParameters(String userId) async {
    String nameAndSurname = _nameAndSurnameController.text;
    String city = _ciudad;
    String age = _ageController.text;
    String nickname = _nicknameController.text;

    await Firestore.instance.collection('usuarios').document(userId).setData(({
          'nombre': nameAndSurname,
          'ciudad': city,
          'edad': age,
          'nickname': nickname,
        }));
    Autenticacion.userSignInCorrectly(context);
  }
}
