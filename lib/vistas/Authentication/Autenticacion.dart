

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/main.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';

class Autenticacion{
  static void userSignInCorrectly(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  static void userSignInIncorrectly(){

  }
}