import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/middleware/MultipleCollectionStreamSystem.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/enumerados/EstadoActividad.dart';

import '../modelos/Paquete.dart';
import '../modelos/Viaje.dart';

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
        .map((snapshot) => Paquete.fromSnapshot(snapshot))
        .where((paquete) => paquete.remitente == usuario);
    var viajes = snapshot.data[Viaje].documents
        .map((snapshot) => Viaje.fromSnapshot(snapshot))
        .where((viaje) => viaje.transportista == usuario);
    var resultados = new List.from(paquetes)..addAll(viajes);

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          final item = resultados.elementAt(index);
          if (item is Paquete)
            return obtenerCardPaquete(item);
          else if (item is Viaje)
            return obtenerCardViaje(item);
          else
            return null;
        });
  }

  static Widget obtenerCardPaquete(Paquete paquete) {
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
                        paquete.origen.ciudad ?? "No disponible",
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
                        paquete.destino?.direccion ?? "No disponible",
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
                    children: <Widget>[
                      Text(
                        paquete.destino?.direccion ?? "No disponible",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic),
                      ),
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

  static Widget obtenerCardViaje(Viaje viaje) {
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
            height: 100,
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
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
