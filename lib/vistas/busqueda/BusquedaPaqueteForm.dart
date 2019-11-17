import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/middleware/PuntosBD.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/Puntos.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

import 'BusquedaFormCiudades.dart';

class BusquedaPaqueteForm extends StatefulWidget {
  @override
  _BusquedaPaqueteFormState createState() => _BusquedaPaqueteFormState();
}

class _BusquedaPaqueteFormState extends BusquedaFormCiudadesState<BusquedaPaqueteForm> {
  _BusquedaPaqueteFormState()
      : super(
            titulo: "Buscar Paquete",
            coleccionBD: "paquetes",
            textoResultados: "Paquetes encontrados");

  List<Puntos> listaPuntos = List<Puntos>();

  @override
  bool buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return false;

    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaResultados.clear();
    var now = new DateTime.now();

    for (DocumentSnapshot document in coleccion) {
      Puntos puntosDocument = Puntos(
        destino: PuntoTransportify.fromReference(
          document[PuntosBD.atributo_destino],
          init: true,
        ),
        origen: PuntoTransportify.fromReference(
          document[PuntosBD.atributo_origen],
          init: true,
        ),
      );
      var date = document[PaqueteBD.atributo_fecha_entrega].toDate();
      var diff = date.isAfter(now);
      if (puntosDocument == puntos && diff) {
        listaPuntos.add(puntosDocument);
        listaResultados.add(document);
      }
    }

    return true;
  }
  


  @override
  Future<bool> buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) async {
    if (!snapshot.hasData) return false;

    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaResultados.clear();

    for (DocumentSnapshot snapshot in coleccion) {
      PuntoTransportify origenBD = PuntoTransportify.fromReference(PaqueteBD.obtenerOrigen(snapshot));
      PuntoTransportify destinoBD = PuntoTransportify.fromReference(PaqueteBD.obtenerDestino(snapshot));

      await Future.wait([origenBD.waitForInit(), destinoBD.waitForInit()]);

      if (origen == origenBD.ciudad && destino == destinoBD.ciudad) {
        listaResultados.add(snapshot);
      }
    }

    return true;
  }
  
  @override
  Widget builderListado(BuildContext context, int index) {
    return InkWell(
      child: Center(
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Column(
                    children: [
                  
                Row(
                    children: [
                      Text(
                        'Dir Origen: ${puntos.origen.direccion}',
                        textAlign: TextAlign.center,
                        style: TextStyle ( color : Colors.black, fontSize: 18),      
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Text(
                        'Dir Destino: ${puntos.destino.direccion}',
                        textAlign: TextAlign.right,
                        style: TextStyle ( color : Colors.black, fontSize: 18),      
                      ),
                    ],
                  ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  
                  Row(
                    children: [
                      Text(
                        'Precio:',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        ' ${listaResultados[index]['Precio'] ?? 'No'}',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Peso: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index]['peso']}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Frágil: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        listaResultados[index]['fragil'] ? 'Sí' : 'No',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  
                  Row(
                    children: [
                      Text(
                        'Alto: ',
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index]['alto']} cm',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Ancho: ',
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index]['ancho']} cm',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Largo: ',
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        '${listaResultados[index]['largo']} cm',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
            ],
          ),
        ),
      ),
      onTap: () {
        print('Has pulsado un paquete');
      },
    );
  }

}
