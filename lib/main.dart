import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

void main() => runApp(MyApp());

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
  final List<PuntoTransportify> puntosTransportify = [];

  Widget _buildListItemPuntosTransportify(BuildContext context, DocumentSnapshot snapshot) {
    PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);
    puntosTransportify.add(punto);

    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Nombre: ${punto.nombre}',
          ),
          Text(
            'Direccion: ${punto.direccion}',
          ),
          Text(
            'Latitud: ${punto.latitud}',
          ),
          Text(
            'Longitud: ${punto.longitud}',
          ),
        ],
      ),
    );
  }

  Widget _buildListaPuntosTransportify(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return const Text('Cargando...');
    return ListView.builder(
      itemExtent: 100.0,
      itemCount: snapshot.data.documents.length,
      itemBuilder: (context, index) =>
          _buildListItemPuntosTransportify(context, snapshot.data.documents[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: StreamBuilder(
          stream:
              Firestore.instance.collection('puntos_transportify').snapshots(),
          builder: _buildListaPuntosTransportify,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Crear Viaje')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Crear Paquete')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Seguimiento')
          )
        ],
        selectedItemColor: Colors.blue[800],), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
