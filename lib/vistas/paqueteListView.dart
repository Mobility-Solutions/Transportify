
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

class PaqueteListView extends StatefulWidget {

  @override
  _PaqueteListViewState createState() => _PaqueteListViewState();
}

class _PaqueteListViewState extends State<PaqueteListView>{

  static bool pressed = false;
  static int paquetesEncontrados = 0;
  String _ciudadOrigenSeleccionada;
  String _ciudadDestinoSeleccionada;
  static String idPuntoOrigen = '';
  static String idPuntoDestino = '';
  static List<DocumentSnapshot> listaPaquetes = List<DocumentSnapshot>();
  
  //paquetesEncontrados = listaPaquetes.length;
  
  @override
  Widget build(BuildContext context) {

   
    

    
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Paquete"),
      ),
      body: 
        Column(
          children:[
            
            Text(
              'Punto Origen',
              textAlign: TextAlign.center,
              style: TextStyle (fontSize: 20),
            ),

            Expanded(
              child:
                obtenerDropDownCiudadesYListadoPuntos(
                  onCiudadChanged: (nuevaCiudad) {
                    setState(() {
                      this._ciudadOrigenSeleccionada = nuevaCiudad;
                      idPuntoOrigen = _ciudadOrigenSeleccionada;
                    });
                  },
                  puntoSeleccionado: _ciudadOrigenSeleccionada,
                ),
            ),

            Text(
              'Punto Destino',
              textAlign: TextAlign.center,
              style: TextStyle (fontSize: 20),
            ),

            
              
            Expanded(
              child:
                obtenerDropDownCiudadesYListadoPuntos(
                  onCiudadChanged: (nuevaCiudad) {
                    setState(() {
                      this._ciudadDestinoSeleccionada = nuevaCiudad;
                      idPuntoDestino = _ciudadDestinoSeleccionada;
                      print(_ciudadDestinoSeleccionada);
                    });
                  },
                  puntoSeleccionado: _ciudadDestinoSeleccionada,
                ),
            ),
            resultadosBusqueda,
            new Expanded(
              child: sacarListaPaquetes(),
            )      
          ],
        ),
      backgroundColor: TransportifyColors.primarySwatch,
    );
  }

  

  static Widget resultadosBusqueda = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        Container(
          margin: const EdgeInsets.all(10),
          child: 
            Text(
              'Paquetes encontrados:  ${paquetesEncontrados}',
              style: TextStyle ( color : Colors.white, fontSize: 20),
            ),
          
        ),
          Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            
            child:
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: (){
                
                print('botón pulsado');
                
              },
            ),
          ),
          ],
        ),
    );
  

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
      return Datos.obtenerStreamBuilderCollectionBD('paquetes', builder);
    }
  
  static Widget sacarListaPaquetes () {
    return obtenerStreamBuilderListado(obtenerListaBuilder());
  }

  static Function (BuildContext, AsyncSnapshot<QuerySnapshot>)
    obtenerListaBuilder(){
      return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _sacarListaPaquetes(context,snapshot);
    };
  }

  static Widget _sacarListaPaquetes(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if (!snapshot.hasData) return const Text('Cargando...');
    List<DocumentSnapshot> coleccion = snapshot.data.documents;

    for (int i = 0; i<coleccion.length;i++){
      if(coleccion[i]['id_destino'].toString() == idPuntoDestino && coleccion[i]['id_origen'].toString() == idPuntoOrigen){
        listaPaquetes.add(coleccion[i]);
      }
    }

    return ListView.separated(
          padding : const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
          itemCount : listaPaquetes.length,
          itemBuilder : (BuildContext context, int index) {
            return InkWell(
              child: 
              Center(
                child:
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(5),
                  height: 70,
                  child: Row(         
                    children: [
                      Expanded(
                        child:
                      Column(
                        
                        children: [
                          Text(
                            'Precio: ${listaPaquetes[index]['Precio']}',
                            textAlign: TextAlign.right,
                            style: TextStyle ( color : Colors.grey[500], fontSize: 20),
                            
                          ),
                          Text(
                            'Peso: ${listaPaquetes[index]['peso']}',
                            textAlign: TextAlign.left,
                            style: TextStyle ( color : Colors.grey[500], fontSize: 20),
                          ),
                          Text(
                            'Fragilidad: ${listaPaquetes[index]['fragil']}',
                            textAlign: TextAlign.left,
                            style: TextStyle ( color : Colors.grey[500], fontSize: 20),
                          ),
                          
                        ],
                      ),
                      ),
                      Expanded(
                        child:
                      Column(
                        children: [
                          Text(
                            'Alto: ${listaPaquetes[index]['alto']}',
                            style: TextStyle ( color : Colors.grey[500], fontSize: 20),
                          ),
                          Text(
                            'Ancho: ${listaPaquetes[index]['ancho']}',
                            style: TextStyle ( color : Colors.grey[500], fontSize: 20),
                          ),
                          Text(
                            'Largo: ${listaPaquetes[index]['largo']}',
                            style: TextStyle ( color : Colors.grey[500], fontSize: 20),
                          ),
                          
                        ],
                      ),
                      ),
                    ],
                  ),
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

  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListadoPuntos(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD('puntos_transportify', builder);
  }

  static Widget obtenerDropDownCiudadesYListadoPuntos(
      {Function(String) onCiudadChanged,
      String puntoSeleccionado,
      Function(PuntoTransportify) onPuntoChanged}) {
    return obtenerStreamBuilderListadoPuntos(
        _obtenerDropDownBuilder(onCiudadChanged, puntoSeleccionado, onPuntoChanged));
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      _obtenerDropDownBuilder(Function(String) onCiudadChanged,
          String puntoSeleccionado, Function(PuntoTransportify) onPuntoChanged) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerDropDownCiudadesYListadoPuntos(
          context, snapshot, onCiudadChanged, puntoSeleccionado, onPuntoChanged);
    };
  }

  static Widget _obtenerDropDownCiudadesYListadoPuntos(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Function(String) onCiudadChanged,
      String puntoSeleccionado,
      Function(PuntoTransportify) onPuntoChanged) {
    if (!snapshot.hasData) return const Text('Cargando...');

    List<DropdownMenuItem<String>> items = [];
        List<DocumentSnapshot> coleccion = snapshot.data.documents;

    
    for (int i = 0; i<coleccion.length; i++) {
      if(coleccion[i]['direccion'] != null)
        items.add(
          DropdownMenuItem<String>(
            child: Text(coleccion[i]['ciudad']+', '+coleccion[i]['direccion']),
            value: coleccion[i].documentID,
          ),
        );
    }

    

    return Column(
      children: [
        DropdownButton<String>(
          isExpanded: false,
          iconSize: 20,
          items: items,
          onChanged: onCiudadChanged,
          value: puntoSeleccionado,
          hint: Text('Selecciona un Punto'),
        ),
        SizedBox(height: 50)
      ],
        
        
      
      
    );
  }



}