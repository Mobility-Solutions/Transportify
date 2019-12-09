import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/middleware/ViajeBD.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/Viaje.dart';
import 'package:transportify/modelos/Incidencia.dart';
import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/inicio/WidgetInicial.dart';
import 'package:transportify/vistas/dialog/PaquetesDialog.dart';
import 'package:transportify/vistas/creacion/CreacionPaqueteForm.dart';
import 'package:transportify/vistas/busqueda/BusquedaPaqueteForm.dart';
import 'package:transportify/vistas/perfil/PerfilUsuarioView.dart';
import 'package:transportify/vistas/creacion/CreacionViajeForm.dart';
import 'package:transportify/vistas/busqueda/BusquedaViajeForm.dart';
import 'package:transportify/vistas/dialog/ViajeDialog.dart';
import 'package:transportify/vistas/seguimiento/IncidenciasView.dart';

import 'InicioPart.dart';

class MyHomePage extends StatefulWidget implements WidgetInicial {
  final Usuario usuario;
  final VoidCallback logoutCallback;

  MyHomePage({Key key, this.usuario, this.logoutCallback}) : super(key: key);

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(usuario: usuario, logoutCallback: this.logoutCallback);
}

class _MyHomePageState extends State<MyHomePage> {
  final Usuario usuario;
  final VoidCallback logoutCallback;

  _MyHomePageState({this.usuario, this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TransportifyColors.homeBackgroundSwatch,
        body: ListView(children: <Widget>[
          TopPart(usuario: usuario, logoutCallback: logoutCallback),
          CrearPaquetePart(usuario: usuario),
          CrearViajePart(usuario: usuario),
          BuscarPart(usuario: usuario),
        ]));
  }
}

abstract class UserDependantStatelessWidget extends StatelessWidget {
  final Usuario usuario;
  UserDependantStatelessWidget(this.usuario);
}

class TopPart extends UserDependantStatelessWidget {
  final VoidCallback logoutCallback;

  TopPart({Usuario usuario, this.logoutCallback}) : super(usuario);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150.0,
        color: TransportifyColors.primarySwatch[50],
        child: Material(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.rotate(
                    angle: pi,
                    child: IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: TransportifyColors.appBackground,
                      ),
                      onPressed: logoutCallback,
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: TransportifyColors.appBackground,
                      ),
                      onPressed: () {
                        // TODO: llevar a la pantalla de preferencias.
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return PerfilUsuarioView(usuario);
                          }));
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
                          List<Incidencia> incidenciasList = [];
                          Paquete paquete = new Paquete(
                            fechaCreacion: DateTime(2019, 12, 1),
                            fechaEntrega: DateTime(2019, 12, 10),
                            diasMargen: 1,
                            estado: EstadoPaquete.en_envio,
                            nombre: "Tarjeta gráfica",
                            incidencias: incidenciasList,
                          );
                          return IncidenciasView(usuario, paquete);
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

class CrearPaquetePart extends UserDependantStatelessWidget {
  CrearPaquetePart({Usuario usuario}) : super(usuario);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Paquete paquete = await PaquetesDialog.show(context, usuario: usuario);
        if (paquete != null) {
          if (paquete is Paquete) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return CreacionPaqueteForm(miPaquete: paquete, usuario: usuario);
            }));
          }
        }
      },
      child: InicioPart(
        usuario: usuario,
        titulo: "¿Quieres enviar un paquete?",
        colorExterior: TransportifyColors.primarySwatch[500],
        colorInterior: TransportifyColors.primarySwatch[50],
        elementos: <InicioPartItem>[
          InicioPartItem(
            icono: Icon(
              Icons.control_point_duplicate,
              size: 30,
              color: Colors.white30,
            ),
            texto:
                "Crea un paquete para que un transportista se ocupe de su envío.",
          ),
        ],
        dato: Row(
          children: [
            usuario == null
                ? const Text(
                    "-",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70),
                  )
                : Datos.obtenerStreamBuilderDocumentBDFromReference(
                    usuario.reference, (context, snapshot) {
                    if (!snapshot.hasData) return const Text("Cargando...");
                    usuario.loadFromSnapshot(snapshot.data);
                    return Text(
                      usuario.paquetesCreados.toString(),
                      style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70),
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
      ),
    );
  }
}

class CrearViajePart extends UserDependantStatelessWidget {
  CrearViajePart({Usuario usuario}) : super(usuario);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Viaje viaje = await ViajeDialog.show(context, usuario: usuario);
        if (viaje != null) {
          if (viaje is Viaje) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return CreacionViajeForm(
                  viajeModificando: viaje, usuario: usuario);
            }));
          }
        }
      },
      child: InicioPart(
        usuario: usuario,
        titulo: "¿Quieres transportar un paquete?",
        colorExterior: TransportifyColors.primarySwatch[900],
        colorInterior: TransportifyColors.primarySwatch[500],
        elementos: <InicioPartItem>[
          InicioPartItem(
            icono: Icon(
              Icons.control_point_duplicate,
              size: 30,
              color: Colors.white30,
            ),
            texto:
                "Crea un viaje para transportar paquetes entre nuestros puntos Transportify",
          ),
        ],
        dato: Row(
          children: [
            usuario == null
                ? const Text(
                    "-",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70),
                  )
                : Datos.obtenerStreamBuilderDocumentBDFromReference(
                    usuario.reference, (context, snapshot) {
                    if (!snapshot.hasData) return const Text("Cargando...");

                    usuario.loadFromSnapshot(snapshot.data);
                    return Text(
                      usuario.viajesCreados.toString(),
                      style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70),
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
      ),
    );
  }
}

class BuscarPart extends UserDependantStatelessWidget {
  BuscarPart({Usuario usuario}) : super(usuario);

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
    return InicioPart(
      titulo: "Busca Paquetes y Viajes",
      colorExterior: TransportifyColors.homeBackgroundSwatch,
      colorInterior: TransportifyColors.primarySwatch[900],
      elementos: [
        InicioPartItemConGestureDetector(
          texto: "Busca Paquetes disponibles.",
          icono: Icon(
            Icons.directions,
            size: 30,
            color: Colors.white30,
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return BusquedaPaqueteForm(usuario: usuario);
            }));
          },
        ),
        InicioPartItemConGestureDetector(
          texto: "Busca Viajes disponibles.",
          icono: Icon(
            Icons.directions,
            size: 30,
            color: Colors.white30,
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return BusquedaViajeForm(usuario: usuario);
            }));
          },
        ),
      ],
      dato: Row(
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
    );
  }
}
