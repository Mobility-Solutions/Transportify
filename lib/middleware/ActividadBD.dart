import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/middleware/MultipleCollectionStreamSystem.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/enumerados/EstadoActividad.dart';
import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';
import 'package:transportify/vistas/creacion/CreacionPaqueteForm.dart';
import 'package:transportify/vistas/creacion/CreacionViajeForm.dart';
import 'package:transportify/vistas/seguimiento/IncidenciasView.dart';

import '../modelos/Paquete.dart';
import '../modelos/Viaje.dart';

enum ConfirmAction { ACCEPT, CANCEL }

class ActividadBD {
  static const String coleccion_viajes = 'viajes';
  static const String coleccion_paquetes = 'paquetes';
  
  static StreamBuilder<Map<Type, QuerySnapshot>> obtenerStreamBuilderListado(
          Function(BuildContext, AsyncSnapshot<Map<Type, QuerySnapshot>>)
              builder,
          MultipleCollectionStreamSystem multipleCollectionStreamSystem) =>
      Datos.obtenerStreamBuilderFromMultipleCollectionStreamSystem(
          multipleCollectionStreamSystem, builder);

  static Widget obtenerListaActividadesCards(
      {Usuario usuario,
      @required MultipleCollectionStreamSystem multipleCollectionStreamSystem,
      EstadoActividad estado}) {
    return obtenerStreamBuilderListado(
        _obtenerListaActividadesBuilder(usuario, estado),
        multipleCollectionStreamSystem);
  }

  static Function(BuildContext, AsyncSnapshot<Map<Type, QuerySnapshot>>)
      _obtenerListaActividadesBuilder(Usuario usuario, EstadoActividad estado) {
    return (BuildContext context,
        AsyncSnapshot<Map<Type, QuerySnapshot>> snapshot) {
      return _obtenerListaActividadesCards(context, snapshot, usuario, estado);
    };
  }

  static Widget _obtenerListaActividadesCards(
      BuildContext context,
      AsyncSnapshot<Map<Type, QuerySnapshot>> snapshot,
      Usuario usuario,
      EstadoActividad estado) {
    if (!snapshot.hasData)
      return const Center(child: const CircularProgressIndicator());

    var paquetes = snapshot.data[Paquete].documents
        .map((snapshot) => Paquete.fromSnapshot(snapshot));
    
    var viajes = snapshot.data[Viaje].documents
        .map((snapshot) => Viaje.fromSnapshot(snapshot));

    if (estado == EstadoActividad.PUBLICADO) {
      paquetes = paquetes?.where((paquete) =>
          (paquete?.remitente == usuario) &&
          paquete?.viajeAsignado == null && paquete?.estado != EstadoPaquete.cancelado);
      viajes = viajes.where((viaje) => viaje.transportista == usuario && viaje?.cancelado == false);
    } else if (estado == EstadoActividad.ENCURSO) {
      paquetes = paquetes?.where((paquete) =>
          (paquete?.remitente == usuario) &&
          paquete?.viajeAsignado != null);
      viajes = [];
    } else if (estado == EstadoActividad.FINALIZADO) {
      paquetes = paquetes?.where((paquete) =>
          (paquete?.remitente == usuario) &&
          paquete?.estado == EstadoPaquete.entregado || paquete?.estado == EstadoPaquete.cancelado);
      viajes = viajes?.where((viaje) =>
          (viaje?.transportista == viaje) &&
          viaje.fecha.difference(DateTime.now()).inDays < 0 || viaje?.cancelado == true );
    }

    var resultados = new List.from(paquetes)..addAll(viajes);

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          final item = resultados.elementAt(index);
          return FutureBuilder(
            future: item.waitForInit(),
            builder:(context,_) {
              if (item is Paquete) return obtenerCardPaquete(item, estado, context,usuario);
          else if (item is Viaje) return obtenerCardViaje(item, estado, context, paquetes);
          else return null;
            }
          );
        });
  }

  static Widget obtenerCardPaquete(
      Paquete paquete, EstadoActividad estado, BuildContext context,Usuario usuario) {
    return Card(
      color: Colors.grey[100],
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            height: 150.0,
            width: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(
                        "https://image.flaticon.com/icons/png/128/679/679720.png"))),
          ),
          Flexible(
              child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    paquete.nombre,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[500],
                      ),
                      Text(
                        paquete.origen.direccion ?? "No disponible",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
                  Row(
                    children: <Widget>[
                      Text(
                        paquete.destino.direccion ?? "No disponible",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      paquete.estado == EstadoPaquete.cancelado
                      ? Text(
                              "CANCELADO",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            )
                      
                      : estado == EstadoActividad.FINALIZADO
                          ? Text(
                              "FINALIZADO",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            )
                          : Text(
                              paquete.fechaEntrega
                                          .difference(DateTime.now())
                                          .inDays >
                                      0
                                  ? "faltan " +
                                      paquete.fechaEntrega
                                          .difference(DateTime.now())
                                          .inDays
                                          .toString() +
                                      " días para la entrega"
                                  : "TU PAQUETE HA EXPIRADO",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                      estado == EstadoActividad.PUBLICADO
                          ? Row(children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) =>
                                              CreacionPaqueteForm(
                                                miPaquete: paquete,
                                              )));
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _asyncConfirmDialog(
                                          context, "¿Desea cancelar el paquete?")
                                      .then((onValue) {
                                    if (onValue == ConfirmAction.ACCEPT) {
                                      paquete.estado = EstadoPaquete.cancelado;
                                      paquete.updateBD();
                                    }
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ])
                          : estado == EstadoActividad.ENCURSO
                              ? Row(children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute<Null>(
                                              builder: (BuildContext context) =>
                                                  CreacionPaqueteForm(
                                                    miPaquete: paquete,
                                                  )));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.trending_up,
                                        color: Colors.purple),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute<Null>(
                                              builder: (BuildContext context) =>
                                                  IncidenciasView(usuario,paquete)));
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ])
                              : SizedBox(
                                  width: 1,
                                )
                    ],
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  static Widget obtenerCardViaje(
      Viaje viaje, EstadoActividad estado, BuildContext context, Iterable<Paquete> paquetes) {
    return Card(
      color: Colors.grey[100],
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            height: 150.0,
            width: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(
                        "https://image.flaticon.com/icons/png/128/664/664468.png"))),
          ),
          Flexible(
              child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Viaje a " +
                        viaje.destino +
                        " del " +
                        viaje.fecha.day.toString() +
                        "/" +
                        viaje.fecha.month.toString() +
                        " a las " +
                        viaje.fecha.hour.toString() +
                        ":" +
                        viaje.fecha.minute.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[500],
                      ),
                      Text(
                        viaje.origen,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
                  Row(
                    children: <Widget>[
                      Text(
                        viaje.destino,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      viaje.cancelado == true
                      ? Text(
                              "CANCELADO",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            )
                      
                      : estado == EstadoActividad.FINALIZADO
                      
                          ? Text(
                              "FINALIZADO",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            )
                          : Text(
                              viaje.fecha.difference(DateTime.now()).inDays > 0
                                  ? "faltan " +
                                      viaje.fecha
                                          .difference(DateTime.now())
                                          .inDays
                                          .toString() +
                                      " días para la entrega"
                                  : "TU VIAJE HA EXPIRADO",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                      estado == EstadoActividad.PUBLICADO
                          ? Row(children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) =>
                                              CreacionViajeForm(
                                                viajeModificando: viaje,
                                              )));
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _asyncConfirmDialog(
                                          context, "¿Desea cancelar el viaje?")
                                      .then((onValue) {
                                    if (onValue == ConfirmAction.ACCEPT){
                                      cancelarViaje(viaje, paquetes);
                                    }
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ])
                              : SizedBox(
                                  width: 1,
                                )
                    ],
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  static Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, String title) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  static cancelarViaje(Viaje viaje, Iterable<Paquete> paquetes){
    
    viaje.cancelado=true;
    
    paquetes = paquetes?.where((paquete) =>
          (paquete?.viajeAsignado == viaje));
    
    for(int i = 0; i<paquetes.length; i++){
      Paquete paquete = paquetes.elementAt(i) ;
      paquete.viajeAsignado=null;
      paquete.estado = EstadoPaquete.por_recoger;
      paquete.updateBD();
    }
    viaje.updateBD();
  }
}
