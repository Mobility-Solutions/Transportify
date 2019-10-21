import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/Datos.dart';

class EnviosBD {
  static const String coleccion_envios = 'envios';

  static const String atributo_estado = 'estado';
  static const String atributo_id_paquete = 'id_paquete';
  static const String atributo_id_viaje = 'id_viaje';

  static String obtenerEstado(DocumentSnapshot snapshot) => snapshot[atributo_estado];
  static String obtenerIdPaquete(DocumentSnapshot snapshot) => snapshot[atributo_id_paquete];
  static String obtenerIdViaje(DocumentSnapshot snapshot) => snapshot[atributo_id_viaje];

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>) _obtenerListaEnviosBuilder(Function(int estado) onTapMethod) {
      Function(BuildContext, AsyncSnapshot<dynamic>) listaEnviosBuilder =  (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) return const Text('Cargando...');
        
        //Metodo constructor del dropdown
        Widget listView;

        listView = new ListView(
            children: snapshot.data.documents.map<Widget>((document) {
              return new ListTile(           
              title: new Text("Id paquete: " + document['id_paquete']),
              onTap: ()=>onTapMethod(document['estado']),
              );
            }).toList(),
        );
          
        return listView;
      };

      return listaEnviosBuilder;
  }

  static Widget obtenerListaEnvios(Function(int estado) onTapMethod){
    var builder = _obtenerListaEnviosBuilder(onTapMethod);
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_envios, builder);
  }
}
