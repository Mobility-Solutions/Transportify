import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BusquedaFormPuntos.dart';

class PaqueteListView extends StatefulWidget {
  @override
  _PaqueteListViewState createState() => _PaqueteListViewState();
}

class _PaqueteListViewState extends BusquedaFormPuntosState<PaqueteListView> {
  _PaqueteListViewState()
      : super(
            titulo: "Buscar Paquete",
            atributoBD: "paquetes",
            textoResultados: "Paquetes encontrados");

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
                        ' ${listaResultados[index]['Precio']}',
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
                        '${listaResultados[index]['fragil']}',
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
        ),
      ),
      onTap: () {
        print('Has pulsado un paquete');
      },
    );
  }
}
