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





















































/*
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_envios, builder);
  }

  static Widget obtenerDropDownCiudadesYListadoPuntos(
      {Function(String) onCiudadChanged,
      String ciudadValue,
      Function(PuntoTransportify) onPuntoChanged}) {
    return obtenerStreamBuilderListado(
        _obtenerDropDownBuilder(onCiudadChanged, ciudadValue, onPuntoChanged));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerDropDownBuilder(Function(String) onCiudadChanged,
          String ciudadValue, Function(PuntoTransportify) onPuntoChanged) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerDropDownCiudadesYListadoPuntos(
          context, snapshot, onCiudadChanged, ciudadValue, onPuntoChanged);
    };
  }

  static Widget _obtenerDropDownCiudadesYListadoPuntos(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Function(String) onCiudadChanged,
      String ciudadSeleccionada,
      Function(PuntoTransportify) onPuntoChanged) {
    if (!snapshot.hasData) return const Text('Cargando...');

    List<DropdownMenuItem<String>> items = [];
    var ciudades =
        snapshot.data.documents.map((doc) => doc[atributo_id_viaje]).toSet();

    for (String ciudad in ciudades) {
      if (ciudad != null && ciudad.length > 0) {
        items.add(
          DropdownMenuItem<String>(
            child: Text(ciudad),
            value: ciudad,
          ),
        );
      }
    }

    var puntosDeLaCiudad = _obtenerPuntosDeLaCiudad(
      puntos: snapshot.data.documents,
      ciudad: ciudadSeleccionada,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          items: items,
          onChanged: onCiudadChanged,
          value: ciudadSeleccionada,
        ),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: ListView.builder(
              itemExtent: 30.0,
              itemCount: ciudades.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < puntosDeLaCiudad.length) {
                  var punto = puntosDeLaCiudad.elementAt(index);
                  return _obtenerListViewItem(punto, onPuntoChanged);
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  static Iterable<DocumentSnapshot> _obtenerPuntosDeLaCiudad(
      {Iterable<DocumentSnapshot> puntos, String ciudad}) {
    return puntos.where((punto) => punto[atributo_id_viaje] == ciudad);
  }

  static Widget _obtenerListViewItem(
      DocumentSnapshot snapshot, Function(PuntoTransportify) onSelected) {
    PuntoTransportify punto = PuntoTransportify.fromSnapshot(snapshot);

    String texto = punto?.nombre;
    if (texto == null || texto.length == 0) {
      texto = punto?.direccion ?? "<punto-sin-nombre>";
    }

    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(punto);
    }

    return ListTile(
      title: Text(texto),
      onTap: onTap,
    );
  }
}
*/
