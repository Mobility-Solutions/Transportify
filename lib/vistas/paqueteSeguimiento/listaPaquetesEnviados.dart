import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListaPaquetesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

  /*
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new MountainList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection('mountains').document().setData(
            {
              'title': 'Mount Vesuvius',
              'type': 'volcano',
            },
          );
        },
      ),
    );
  }


}

obtenerListaEnvios(){
  return new StreamBuilder(
    stream: Firestore.instance.collection('mountains').snapshots,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) return new Text('Loading...');
      return new ListView(
        children: snapshot.data.documents.map((document) {
          return new ListTile(
            title: new Text(document['title']),
            subtitle: new Text(document['type']),
          );
        }).toList(),
      );
    },
  );
}
class EnviosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('mountains').snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new ListTile(
              title: new Text(document['title']),
              subtitle: new Text(document['type']),
            );
          }).toList(),
        );
      },
    );
  }



  static Widget obtenerDropDown({Function(dynamic) onChanged, dynamic value}) {
    //Se necesita un dropdown con un flujo de datos
    Function(BuildContext, AsyncSnapshot<QuerySnapshot>) dropDownBuilder = _obtenerDropDownBuilder(onChanged, value);
    var dropDownConStream = Datos.obtenerStreamBuilder_PuntosTransportify(dropDownBuilder);
    return dropDownConStream;
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>) _obtenerDropDownBuilder(Function(dynamic) onChanged, dynamic value) {
    Function(BuildContext, AsyncSnapshot<dynamic>) dropDownBuilder =  (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //Metodo constructor del dropdown
      Widget dropDown;

      if (!snapshot.hasData) {
        dropDown = const Text('Cargando...');
      } else {
        List<DropdownMenuItem> items = new List<DropdownMenuItem>();
        for (DocumentSnapshot documentSnapshot in snapshot.data.documents) {
          //PuntoTransportify punto = PuntoTransportify.fromSnapshot(documentSnapshot);
          DropdownMenuItem menuItem =
          DropdownMenuItem(
            child: Text(punto?.nombre ?? ""),
            value: punto,
          );

          items.add(menuItem);
        }

        dropDown = DropdownButton(
            items: items,
            onChanged: onChanged,
            value: value
        );
      }


      return dropDown;
    };
    return dropDownBuilder;
  }

  static StreamBuilder obtenerStreamBuilder_Envios(Function(BuildContext, AsyncSnapshot<dynamic>) builder) {
    //Junta el buildesr con un flujo de datos
    return StreamBuilder(
        stream: Firestore.instance.collection('envios')
            .snapshots(),
        builder: builder
    );

   */

}
