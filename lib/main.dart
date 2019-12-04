import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:transportify/vistas/inicio/RootPage.dart';

void main() async =>
    await initializeDateFormatting("es_ES", null).then((_) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: RootPage()
    );
  }
}
