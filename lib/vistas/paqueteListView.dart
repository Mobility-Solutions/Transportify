
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/middleware/Datos.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';

class PaqueteListView extends StatefulWidget {

  @override
  _PaqueteListViewState createState() => _PaqueteListViewState();
}

class _PaqueteListViewState extends State<PaqueteListView>{

  int paquetesEncontrados;
  List<DocumentSnapshot> listaPaquetes = List<DocumentSnapshot>();
  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  PuntoTransportify puntoOrigen, puntoDestino;
  bool visibilityList = false;
  Text textoNPaquetes;
  Visibility listaResultado;
  final _formKey = GlobalKey<FormState>();



  Future<Null> getTransportifyPoint(bool origen) async {
    PuntoTransportify returnPunto = await showDialog(
        context: this.context,
        builder: (_) {
          return PuntosDialog();
        });
    if (returnPunto != null) {
      if (origen) {
        puntoOrigen = returnPunto;
        origenController.text = puntoOrigen?.nombre;
      } else if (!origen) {
        puntoDestino = returnPunto;
        destinoController.text = puntoDestino?.nombre;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
    key:_formKey, 
    child: Scaffold(
      appBar: AppBar(
        title: Text("Buscar Paquete"),
        backgroundColor: TransportifyColors.primarySwatch,
      ),
      body: 
      Padding(
        padding: EdgeInsets.only(left:15.0, right: 15.0),
        child:
        Column(
          children:[

                SizedBox(
                  height: 20.0,
                ),

                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  style: TextStyle(color: TransportifyColors.primarySwatch),
                  controller: origenController,
                  decoration:
                      returnInputDecoration("Punto Transportify de origen"),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    getTransportifyPoint(true);
                  },
                  validator: (value) {
                    if (puntoOrigen == null || puntoDestino == null)
                      return 'Introduzca los puntos origen y destino';
                    else if (puntoDestino.id == puntoOrigen.id)
                      return 'Los puntos no deben coincidir.';
                    else
                      return null;
                  },
                ),


                SizedBox(
                  height: 20.0,
                ),

                TextFormField(
                  maxLines: 1,
                  autofocus: false,
                  style: TextStyle(color: TransportifyColors.primarySwatch),
                  controller: destinoController,
                  decoration:
                      returnInputDecoration("Punto Transportify de destino"),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    getTransportifyPoint(false);
                  },
                  validator: (value) {
                    if (puntoOrigen == null || puntoDestino == null){
                      visibilityList = false; listaPaquetes.clear(); 
                      return 'Introduzca los puntos origen y destino';
                      
                    }
                    else if (puntoDestino.id == puntoOrigen.id){
                      visibilityList = false; listaPaquetes.clear();
                      return 'Los puntos no deben coincidir.';
                    }
                    else{
                      visibilityList = true;
                      return null;
                    }
                  },
                ),
  
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      Container(
                        margin: const EdgeInsets.all(10),
                        child:
                          Row(
                            children: <Widget>[
                              Text(
                            'Paquetes encontrados:  ',
                            style: TextStyle ( color : Colors.white, fontSize: 20),
                              ),

                              visibilityList ?
                              textoNPaquetes = new Text(
                                '${paquetesEncontrados}',
                                style: TextStyle ( color : Colors.white, fontSize: 20),
                              ) : new Container(),
                          
                            ],
                          )
                           
                            


                        
                      ),
                        Container(
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: TransportifyColors.primarySwatch[900],
                          ),
                          
                          child:
                          IconButton(
                            icon: Icon(Icons.search),
                            color: Colors.white,
                            onPressed: (){
                              print('botón pulsado');
                              _onChangedVisibility(true);
                             
                            },
                          ),
                        ),
                        ],
                      ),
                  ),
            
                visibilityList ? new Expanded(
                  child: listaResultado = new Visibility(
                  visible: visibilityList,
                  child: sacarListaPaquetes(),
                ),) : new Container(),
             
          ],
        ),
      ),
      backgroundColor: TransportifyColors.primarySwatch,
    ),
    );
  }

  void _onChangedVisibility(bool visibility){
      setState(() {
        if (_formKey.currentState.validate()){
        paquetesEncontrados = listaPaquetes.length;
        listaPaquetes.clear();
        }
      });
  }

  InputDecoration returnInputDecoration(String hintText) {
    return InputDecoration(
      suffixIcon: hintText.startsWith("Punto") ? Icon(Icons.location_on) : null,
      hintText: hintText,
      hintStyle: TextStyle(color: TransportifyColors.primarySwatch),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      );
    }



  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
      return Datos.obtenerStreamBuilderCollectionBD('paquetes', builder);
    }
  
   Widget sacarListaPaquetes () {
    return obtenerStreamBuilderListado(obtenerListaBuilder());
  }

 Function (BuildContext, AsyncSnapshot<QuerySnapshot>)
    obtenerListaBuilder(){
      return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _sacarListaPaquetes(context,snapshot);
    };
  }

  Widget _sacarListaPaquetes(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if (!snapshot.hasData) return const Text('Cargando...');
    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaPaquetes.clear();
    for (int i = 0; i<coleccion.length;i++){
      if(coleccion[i]['id_destino'].toString() == puntoDestino.id && coleccion[i]['id_origen'].toString() == puntoOrigen.id){
        listaPaquetes.add(coleccion[i]);
      }
    }
    paquetesEncontrados = listaPaquetes.length;
    
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
                  height: 70,
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,       
                    children: [
                      Column(
                        children:[
                          Row(
                            children: [
                              Text(
                                'Precio:',
                                textAlign: TextAlign.right,
                                style: TextStyle ( color : Colors.grey[500], fontSize: 18),      
                              ),

                              Text(
                                ' ${listaPaquetes[index]['Precio']}',
                                textAlign: TextAlign.right,
                                style: TextStyle ( color : Colors.black, fontSize: 18),      
                              ),
                            ],
                          ),

                          Row(
                            children: [

                              Text(
                            'Peso: ',
                              textAlign: TextAlign.left,
                              style: TextStyle ( color : Colors.grey[500], fontSize: 18),
                            ),

                            Text(
                            '${listaPaquetes[index]['peso']}',
                              textAlign: TextAlign.left,
                              style: TextStyle ( color : Colors.black, fontSize: 18),
                            ),

                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                'Fragilidad: ',
                                textAlign: TextAlign.left,
                                style: TextStyle ( color : Colors.grey[500], fontSize: 18),
                              ),

                              Text(
                                '${listaPaquetes[index]['fragil']}',
                                textAlign: TextAlign.left,
                                style: TextStyle ( color : Colors.black, fontSize: 18),
                              ),

                            ],
                          )
                          
                          
                          ],
                        ),

                       
                      Column(
                        children: [
                          Row(
                            children:[
                              Text(
                                'Alto: ',
                                style: TextStyle ( color : Colors.grey[500], fontSize: 18),
                              ),

                              Text(
                                '${listaPaquetes[index]['alto']} cm',
                                style: TextStyle ( color : Colors.black, fontSize: 18),
                              ),
                            ],
                          ),
                          
                          Row(
                            children: <Widget>[
                              Text(
                                'Ancho: ',
                                style: TextStyle ( color : Colors.grey[500], fontSize: 18),
                              ),

                              Text(
                                '${listaPaquetes[index]['ancho']} cm',
                                style: TextStyle ( color : Colors.black, fontSize: 18),
                              ),

                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Text(
                                'Largo: ',
                                style: TextStyle ( color : Colors.grey[500], fontSize: 18),
                              ),

                              Text(
                                '${listaPaquetes[index]['largo']} cm',
                                style: TextStyle ( color : Colors.black, fontSize: 18),
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
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        );
  }




}


class PuntosDialog extends StatefulWidget {
  @override
  _PuntosDialogState createState() => new _PuntosDialogState();
}

class _PuntosDialogState extends State<PuntosDialog> {
  String _ciudadSeleccionada;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Puntos Transportify"),
        content: Container(
            height: 300,
            width: 300,
            child: Center(
              child: PuntoTransportifyBD.obtenerDropDownCiudadesYListadoPuntos(
                onPuntoChanged: (nuevoPunto) {
                  Navigator.pop(context, nuevoPunto);
                },
                onCiudadChanged: (nuevaCiudad) {
                  setState(() {
                    this._ciudadSeleccionada = nuevaCiudad;
                  });
                },
                ciudadValue: _ciudadSeleccionada,
              ),
            )));
  }
}
