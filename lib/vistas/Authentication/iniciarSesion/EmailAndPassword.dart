/*EMAIL*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transportify/middleware/UsuarioBD.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/Authentication/Autenticacion.dart';
import 'package:toast/toast.dart';

class EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    // NOTA: Usar try-catch con await es preferible a usar el método catchError(...) the Future.
    // Aunque también funcione (y pueda ser incluso mejor), este causa un bug en VSCode, el cual no
    // entiende que la excepción ha sido capturada, y la muestra como excepción sin tratar, aunque ya lo esté
    // (known issue desde hace meses, no parece que estén trabajando activamente en arreglarlo).
    try {
      try {
        await UsuarioBD.loginConCorreoYPassword(
          correo: _emailController.text,
          password: _passwordController.text,
        );
      } on PlatformException catch (error) {
        print(error);
        // Como se trata de un error de autenticacion, volvemos a lanzarlo como tal para que lo trate.
        // Lo hacemos así para que, si en un futuro se lanza directamente AuthException en lugar de
        // PlatformException, no sea necesario modificar el código, ya que lo capturará directamente.
        throw AuthException(error.code, error.message);
      }
    } on AuthException catch (error) {
      String message;
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          message = "Usuario no válido";
          break;
        case "ERROR_WRONG_PASSWORD":
          message = "Contraseña incorrecta";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          message = "Demasiados intentos incorrectos.\n" +
              "Inténtelo de nuevo más tarde";
          break;
        default:
          message = "Ha habido un error al tratar de iniciar sesión.\n" +
              "Inténtelo de nuevo más tarde";
          print(error);
          break;
      }
      Toast.show(message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

    final Usuario user = await UsuarioBD.obtenerUsuarioActual();
    if (user != null) {
      Autenticacion.userSignInCorrectly(context, user);
    } else {
      Autenticacion.userSignInIncorrectly();
    }
  }

  bool _isEmailCorrectlyFormed(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
