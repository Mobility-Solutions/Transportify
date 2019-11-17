/*EMAIL*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/Authentication/Autenticacion.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              if (!_isEmailCorrectlyFormed(value)) {
                return 'El formato es invalido';
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
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Introduce contraseña',
              labelText: 'Contraseña',
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
                  _signInWithEmailAndPassword();
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
              },
              child: Text(
                "Iniciar sesión",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .catchError((error) {
      if (error.toString().contains("ERROR_USER_NOT_FOUND")) {
        Toast.show("Usuario no valido", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      if (error.toString().contains("ERROR_WRONG_PASSWORD")) {
        Toast.show("Contraseña incorrecta", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }

      if (error.toString().contains("ERROR_TOO_MANY_REQUESTS")) {
        Toast.show(
            "Demasiados intentos incorrectos intentalo mas tarde", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        print(error);
      }
    });
    final FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      Autenticacion.userSignInCorrectly(context);
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      Autenticacion.userSignInIncorrectly();
      _success = false;
    }
  }

  bool _isEmailCorrectlyFormed(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
