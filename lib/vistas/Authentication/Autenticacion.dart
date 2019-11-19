

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/main.dart';

class Autenticacion{
  static void userSignInCorrectly(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  static void userSignInIncorrectly(){

  }
}