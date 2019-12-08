import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/middleware/MultipleCollectionStreamSystem.dart';
import 'package:transportify/modelos/Usuario.dart';

import '../modelos/Paquete.dart';
import '../modelos/Viaje.dart';

class ActividadBD{

  static const String coleccion_viajes = 'viajes';
  static const String coleccion_paquetes = 'paquetes';

  static StreamBuilder<Map<Type, QuerySnapshot>> obtenerStreamBuilderListado(
    Function(BuildContext,
    AsyncSnapshot<Map<Type, QuerySnapshot>>) builder,
    MultipleCollectionStreamSystem multipleCollectionStreamSystem) =>
      Datos.obtenerStreamBuilderFromMultipleCollectionStreamSystem(multipleCollectionStreamSystem,builder);
  
  static Widget obtenerListaActividadesCards(
    {Usuario usuario,@required MultipleCollectionStreamSystem multipleCollectionStreamSystem}){
    return obtenerStreamBuilderListado(
      _obtenerListaActividadesBuilder(usuario),multipleCollectionStreamSystem);
  }

  static Function(BuildContext, AsyncSnapshot<Map<Type, QuerySnapshot>>)
    _obtenerListaActividadesBuilder(
        Usuario usuario) {
          return (BuildContext context, AsyncSnapshot<Map<Type, QuerySnapshot>> snapshot){
            return _obtenerListaActividadesCards(context, snapshot);
          };
        }

  static Widget _obtenerListaActividadesCards(
    BuildContext context, 
    AsyncSnapshot<Map<Type, QuerySnapshot>> snapshot) {
    if (!snapshot.hasData)
      return const Center(child: const CircularProgressIndicator());

    //var listaPaquetes = snapshot.data[Paquete];
    //var listaViajes = snapshot.data[Viaje];

    return ListView.builder(itemBuilder: (context, index) {
      
    });
  }

  static Widget _obtenerCardPaquete(DocumentSnapshot snapshot) {
    Paquete paquete = Paquete.fromSnapshot(snapshot);

    return Card(
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://www.shareicon.net/data/512x512/2015/09/30/648924_boxes_512x512.png"))),
          ),
          Container(
            height: 100,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(paquete.nombre),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget _obtenerCardViaje(DocumentSnapshot snapshot) {
    Viaje viaje = Viaje.fromSnapshot(snapshot);

    return Card(
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://www.shareicon.net/data/512x512/2015/09/30/648924_boxes_512x512.png"))),
          ),
          Container(
            height: 100,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Viaje a "+viaje.destino+" del "+viaje.fecha.toString()+" a las "+viaje.fecha.hour.toString()+":"+viaje.fecha.minute.toString()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}