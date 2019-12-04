import 'package:flutter/material.dart';

import 'WidgetInicial.dart';

class WaitingScreen extends StatelessWidget implements WidgetInicial {
  const WaitingScreen();
  
  @override
  Widget build(BuildContext context) {
    // TODO: Pantalla de carga (splash)
    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}