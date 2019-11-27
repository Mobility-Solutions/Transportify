import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:transportify/vistas/busqueda/BusquedaViajeForm.dart';
import 'package:transportify/vistas/busqueda/BusquedaPaqueteForm.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing
  iniciar();
}

  void iniciar() async =>
    await initializeDateFormatting("es_ES", null).then((_) => runApp(MyApp()));

  class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(fontFamily: 'Quicksand'),
      home: BusquedaPaqueteForm(),

    );
  }

}