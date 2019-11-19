import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:intl/intl.dart';
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

  List<PuntoTransportify> listaPuntosOrigen = List<PuntoTransportify>();
  List<PuntoTransportify> listaPuntosDestino = List<PuntoTransportify>();

  @override
  Future<bool> buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) async {
    if (!snapshot.hasData) return false;

    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    
    var now = new DateTime.now();
    DateTime fechaElegida;
    if(choosenDate != null && choosenTime != null){
    fechaElegida = new DateTime(
        choosenDate.year,
        choosenDate.month,
        choosenDate.day,
        choosenTime.hour,
        choosenTime.minute,
        0);
    }
    else if (choosenTime == null && choosenDate != null){
      fechaElegida = new DateTime(
        choosenDate.year,
        choosenDate.month,
        choosenDate.day,
        0,
        0,
        0);
    }
    else{
      fechaElegida = now;
    }
    listaResultados.clear();
    for (DocumentSnapshot snapshot in coleccion) {

      Paquete paquete = Paquete.fromSnapshot(snapshot);
      await paquete.waitForInit();

      var date = paquete.fechaEntrega;
      var diff = date.isAfter(now);
      var fechaBusqueda = date.isAfter(fechaElegida);
      bool repetido = false;
      for(Paquete aux in listaResultados){
        if(aux == paquete) repetido = true;
      }
      if (origen == paquete.origen.ciudad && destino == paquete.destino.ciudad && diff && fechaBusqueda && paquete.viajeAsignado==null && !repetido) {
        listaPuntosOrigen.add(paquete.origen);
        listaPuntosDestino.add(paquete.destino);
        listaResultados.add(paquete);
      }
    }

    return true;
  }
  
  @override
  Widget builderListado(BuildContext context, int index) {
    return InkWell(
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
                        'Dir Origen: ${listaPuntosOrigen[index].direccion}',
                        textAlign: TextAlign.center,
                        style: TextStyle ( color : Colors.black, fontSize: 18),      
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Text(
                        'Dir Destino: ${listaPuntosDestino[index].direccion}',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    //flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.lightBlue[200],
                          size: 35.0,
                        ),
                        Text(
                          DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, "es_ES")
                              .format(listaResultados[index].fechaEntrega),
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    //flex: 2,
                    child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Precio:',
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.grey[500], fontSize: 18),
                              ),
                              Text(
                                ' ${listaResultados[index].precio ?? 'No'}',
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
                  ),
                  Expanded(
                    //flex: 2,
                    child:
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
                  ),
                ],
              ),
            ],
          ),
        ),
      onTap: () {
        print('Has pulsado un paquete');
      },
    );
  }

}
