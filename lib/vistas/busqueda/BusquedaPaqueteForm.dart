import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Paquete.dart';

import 'BusquedaFormCiudades.dart';

class BusquedaPaqueteForm extends StatefulWidget {
  @override
  _BusquedaPaqueteFormState createState() => _BusquedaPaqueteFormState();
}

class _BusquedaPaqueteFormState extends BusquedaFormCiudadesState<BusquedaPaqueteForm, Paquete> {
  _BusquedaPaqueteFormState()
      : super(
            titulo: "Buscar Paquete",
            coleccionBD: "paquetes",
            textoResultados: "Paquetes encontrados");

  @override
  Future<bool> buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) async {
    if (!snapshot.hasData) return false;

    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaResultados.clear();

    for (DocumentSnapshot snapshot in coleccion) {
      Paquete paquete = Paquete.fromSnapshot(snapshot);
      await paquete.waitForInit();

      if (origen == paquete.origen.ciudad && destino == paquete.destino.ciudad) {
        listaResultados.add(paquete);
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
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        ' ${listaResultados[index].precio ?? 'No establecido'}',
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
                        '${listaResultados[index].peso}',
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
                        listaResultados[index].fragil ? 'Sí' : 'No',
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
                        '${listaResultados[index].alto} cm',
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
                        '${listaResultados[index].ancho} cm',
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
                        '${listaResultados[index].largo} cm',
                        style: TextStyle(color: Colors.black, fontSize: 18),
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
