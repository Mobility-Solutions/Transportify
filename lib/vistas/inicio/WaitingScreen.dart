import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'WidgetInicial.dart';

class WaitingScreen extends StatelessWidget implements WidgetInicial {
  const WaitingScreen();

  @override
  Widget build(BuildContext context) {
    // TODO: Pantalla de carga (splash)
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
              'assets/logo.svg',
              semanticsLabel: 'Logo'
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
