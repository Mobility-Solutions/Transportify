import 'package:flutter/material.dart';

import 'WidgetInicial.dart';

class WaitingScreen extends StatelessWidget implements WidgetInicial {
  const WaitingScreen();

  @override
  Widget build(BuildContext context) {
    // TODO: Pantalla de carga (splash)
    return Scaffold(
      body: Column(
        children: <Widget>[
          Image.network(
              "https://avatars1.githubusercontent.com/u/55597308?s=200&v=4"),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
