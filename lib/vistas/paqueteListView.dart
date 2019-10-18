import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/modelos/Paquete.dart';

class PaqueteListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //final List<Paquete> listaPaquetes = ;

    
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Paquete"),
      ),
      body: puntosOrigenDestino,
      backgroundColor: TransportifyColors.primarySwatch,
    );
  }
  Widget puntosOrigenDestino = Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: [
        
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Punto Origen',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Punto Destino',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        
      ]
    ),
  );

  
  Widget _sacarListaPaquetes(){
    return ListView.separated(
          padding : const EdgeInsets.all(8),
          itemCount : 5,
          itemBuilder : (BuildContext context, int index) {
            return InkWell(
              child:
                Container(
                  height: 50,
                  color: Colors.amber[0],
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Precio: ',
                            style: TextStyle ( color : Colors.grey[500]),
                          ),
                          Text(
                            'Peso: ',
                            style: TextStyle ( color : Colors.grey[500]),
                          ),
                          Text(
                            'Fragilidad: ',
                            style: TextStyle ( color : Colors.grey[500]),
                          ),
                          
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Alto: ',
                            style: TextStyle ( color : Colors.grey[500]),
                          ),
                          Text(
                            'Ancho: ',
                            style: TextStyle ( color : Colors.grey[500]),
                          ),
                          Text(
                            'Largo: ',
                            style : TextStyle ( color : Colors.grey[500]),
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
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        );
  }
}