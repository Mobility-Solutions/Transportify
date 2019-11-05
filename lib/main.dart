import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/creacion/CreacionPaqueteForm.dart';
import 'package:transportify/vistas/busqueda/BusquedaPaqueteForm.dart';
import 'package:transportify/vistas/seguimiento/SeguimientoForm.dart';
import 'package:transportify/vistas/creacion/CreacionViajeForm.dart';
import 'package:transportify/vistas/busqueda/BusquedaViajeForm.dart';

import 'middleware/PuntoTransportifyBD.dart';

void main() async =>
    await initializeDateFormatting("es_ES", null).then((_) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TransportifyColors.homeBackgroundSwatch,
      body: Column(
        children: <Widget>[
            TopPart()
        ]
      )
    );
 // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class TopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      color: TransportifyColors.primarySwatch[50],
      child: Material(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.0),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: TransportifyColors.primarySwatch[900])),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.account_circle,
                          color: TransportifyColors.primarySwatch[900],
                          size: 28.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "PERFIL",
                      style: TextStyle(
                        color: TransportifyColors.primarySwatch[900],
                          fontWeight: FontWeight.w500, fontSize: 12.0),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.pink)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.trending_up,
                          size: 28.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "PAQUETES/VIAJES",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12.0),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300])),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.trending_up,
                          size: 28.0,
                          color: TransportifyColors.primarySwatch[900],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "SEGUIMIENTO",
                      style: TextStyle(
                          color: TransportifyColors.primarySwatch[900],
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
