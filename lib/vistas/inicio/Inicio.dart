import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/modelos/DatosUsuarioActual.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/UsuariosDialog.dart';
import 'package:transportify/vistas/creacion/CreacionPaqueteForm.dart';
import 'package:transportify/vistas/busqueda/BusquedaPaqueteForm.dart';
import 'package:transportify/vistas/perfilUsuarioView.dart';
import 'package:transportify/vistas/seguimiento/SeguimientoForm.dart';
import 'package:transportify/vistas/creacion/CreacionViajeForm.dart';
import 'package:transportify/vistas/busqueda/BusquedaViajeForm.dart';

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
  String numPaquetesYViajes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TransportifyColors.homeBackgroundSwatch,
        body: Center(
            child: ListView( children: <Widget>[
          TopPart(),
          CrearPaquetePart(),
          CrearViajePart(),
          BuscarPart()
        ])));
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
              SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          Usuario usuario = await UsuariosDialog.show(context);
                          if (usuario != null) {
                            DatosUsuarioActual.instance.usuario = usuario;
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                              return PerfilUsuarioView(usuario);
                            }));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      TransportifyColors.primarySwatch[900])),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.account_circle,
                              color: TransportifyColors.primarySwatch[900],
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "   PERFIL  ",
                        style: TextStyle(
                            color: TransportifyColors.primarySwatch[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
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
                            Icons.all_inclusive,
                            color: TransportifyColors.primarySwatch[500],
                            size: 30.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        " ACTIVIDAD ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14.0),
                      )
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new SeguimientoForm();
                        }));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300])),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.trending_up,
                                size: 30.0,
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
                                fontWeight: FontWeight.w500, fontSize: 14.0),
                          )
                        ],
                      ))
                ],
              )
            ],
          ),
        ));
  }
}

class CrearPaquetePart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Usuario usuarioActual = DatosUsuarioActual.instance.usuario;
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new CreacionPaqueteForm();
          }));
        },
        child: Container(
          height: 208.0,
          width: MediaQuery.of(context).size.width,
          color: TransportifyColors.primarySwatch[500],
          child: Material(
            color: TransportifyColors.primarySwatch[50],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 30.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Text(
                        "¿Quieres enviar un paquete?",
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.control_point_duplicate,
                            size: 30,
                            color: Colors.white30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Crea un paquete para que\nun transportista se ocupe\nde su envío.",
                            maxLines: 10,
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 23.0),
                      Row(
                        children: [
                          usuarioActual == null
                              ? const Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white70),
                                )
                              : Datos
                                  .obtenerStreamBuilderDocumentBDFromReference(
                                      usuarioActual.reference,
                                      (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const Text("Cargando...");
                                  usuarioActual.loadFromSnapshot(snapshot.data);
                                  return Text(
                                    usuarioActual.paquetesCreados.toString(),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white70),
                                  );
                                }),
                          Text(
                            " paquetes enviados.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class CrearViajePart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Usuario usuarioActual = DatosUsuarioActual.instance.usuario;
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new CreacionViajeForm();
          }));
        },
        child: Container(
          height: 208.0,
          width: MediaQuery.of(context).size.width,
          color: TransportifyColors.primarySwatch[900],
          child: Material(
            color: TransportifyColors.primarySwatch[500],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 30.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Text(
                        "¿Quieres transportar un paquete?",
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.control_point_duplicate,
                            size: 30,
                            color: Colors.white30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Crea un viaje para\ntransportar paquetes entre\nnuestros puntos Transportify",
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          usuarioActual == null
                              ? const Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white70),
                                )
                              : Datos
                                  .obtenerStreamBuilderDocumentBDFromReference(
                                      usuarioActual.reference,
                                      (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const Text("Cargando...");

                                  usuarioActual.loadFromSnapshot(snapshot.data);
                                  return Text(
                                    usuarioActual.viajesCreados.toString(),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white70),
                                  );
                                }),
                          Text(
                            " viajes realizados.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class BuscarPart extends StatelessWidget {
  Widget getNumDocuments(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return const Text(
        "Cargando...",
        style: TextStyle(
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
          color: Colors.white70,
        ),
      );
    }
    return Text(
      snapshot.data.documents.length.toString(),
      style: TextStyle(
        fontSize: 18.0,
        fontStyle: FontStyle.italic,
        color: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 208.0,
      width: MediaQuery.of(context).size.width,
      color: TransportifyColors.homeBackgroundSwatch,
      child: Material(
        color: TransportifyColors.primarySwatch[900],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    "Busca Paquetes y Viajes",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new BusquedaViajeForm();
                      }));
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.directions,
                          size: 30,
                          color: Colors.white30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Busca Viajes disponibles.",
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new BusquedaPaqueteForm();
                      }));
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.directions,
                          size: 30,
                          color: Colors.white30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Busca Paquetes disponibles.",
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Row(
                    children: <Widget>[
                      Datos.obtenerStreamBuilderCollectionBD(
                          PaqueteBD.coleccion_paquetes, getNumDocuments),
                      Text(
                        " paquetes y ",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                      Datos.obtenerStreamBuilderCollectionBD(
                          ViajeBD.coleccion_viajes, getNumDocuments),
                          Text(
                        " viajes disponibles",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
