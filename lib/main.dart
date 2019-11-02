import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:transportify/vistas/paqueteForm.dart';
import 'package:transportify/vistas/paqueteListView.dart';
import 'package:transportify/vistas/listaPaquetesSeguimientoView.dart';
import 'package:transportify/vistas/viajeForm.dart';
import 'package:transportify/vistas/viajeListView.dart';

import 'middleware/PuntoTransportifyBD.dart';

void main() async => await initializeDateFormatting("es_ES", null).then((_) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  static const String title = 'Transportify';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ciudadSeleccionada;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new PaqueteForm();
        }));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new MyViajeForm();
        }));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new ListaPaquetesSeguimientoView();
        }));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new PaqueteListView();
        }));
        break;
      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new ViajeListView();
        }));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    int _currentIndex = 0;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: PuntoTransportifyBD.obtenerDropDownCiudadesYListadoPuntos(
          onCiudadChanged: (nuevaCiudad) {
            setState(() {
              this._ciudadSeleccionada = nuevaCiudad;
            });
          },
          ciudadValue: _ciudadSeleccionada,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text('Paquete')),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Viaje')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text('Seguimiento')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Paquete')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Viaje')),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _onItemTapped(index);
        },
        selectedItemColor: Colors.blue[800],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
