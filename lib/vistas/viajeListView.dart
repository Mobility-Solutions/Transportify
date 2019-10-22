import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/middleware/ViajeTransportifyBD.dart';
import 'package:transportify/middleware/PuntoTransportifyBD.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/util/style.dart';
import '../middleware/Datos.dart';
import 'package:intl/intl.dart';

class ViajeListView extends StatefulWidget {
  
  ViajeListView({Key key, this.title}) : super(key: key);
  @override
  ViajeListViewState createState() => ViajeListViewState();

  final String title;
}

class ViajeListViewState extends State<ViajeListView> {

  final origenController = TextEditingController();
  final destinoController = TextEditingController();
  static String idPuntoOrigen = '';
  static String idPuntoDestino = '';
  static PuntoTransportify puntoOrigen, puntoDestino;
  static List<DocumentSnapshot> listaViajes = List<DocumentSnapshot>();
  final _formKey = GlobalKey<FormState>();
  int viajesEncontrados = listaViajes.length;
  bool visibilityList = false;
  Text textoNViajes;
  Visibility listaResultado;
  
   StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
      return Datos.obtenerStreamBuilderCollectionBD('viajes', builder);
    }

   Widget sacarListaViajes () {
    return obtenerStreamBuilderListado(obtenerListaBuilder());
  }
  
  void _onChangedVisibility(bool visibility){
        setState(() {
          if (_formKey.currentState.validate()){
          viajesEncontrados = listaViajes.length;
          listaViajes.clear();
          }
        });
    }

   Function (BuildContext, AsyncSnapshot<QuerySnapshot>)
    obtenerListaBuilder(){
      return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _sacarListaViajes(context,snapshot);
    };
  }

  Widget _sacarListaViajes(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if (!snapshot.hasData) return const Text('Cargando...');
    List<DocumentSnapshot> coleccion = snapshot.data.documents;
    listaViajes.clear();
    for (int i = 0; i<coleccion.length;i++){
      if(coleccion[i]['id_destino'].toString() == puntoDestino.id && coleccion[i]['id_origen'].toString() == puntoOrigen.id){
        listaViajes.add(coleccion[i]);
      }
    }
    viajesEncontrados = listaViajes.length;
    return ListView.separated(
          padding: const EdgeInsets.all(8),

          separatorBuilder: (context, index) => Divider(
            color: TransportifyColors.primarySwatch,
          ),

          itemCount: listaViajes.length,

          itemBuilder: (BuildContext context, int index) {
            return InkWell(
            child: Container(
              
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                        ),
                        Icon(
                        Icons.airport_shuttle,
                        color: Colors.lightBlue[200],
                        size: 50.0,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Text('${listaViajes[index]['id_transportista']}', style: TextStyle(fontSize: 18, color: Colors.black, height: 2.5),textAlign: TextAlign.center,),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Text('${listaViajes[index]['carga_maxima']}', style: TextStyle(fontSize: 15, color: Colors.black54, height: 0.8,),textAlign: TextAlign.center,),
                        ],
                      ),

                    ],
                    )    
                  ),

                  Expanded(
                    flex : 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Text('${getDayName(listaViajes[0]['fecha'].toDate().weekday)} ${listaViajes[0]['fecha'].toDate().day}', style: TextStyle(fontSize: 18, color: Colors.black, height: 2.5),textAlign: TextAlign.center,),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Text('${listaViajes[0]['fecha'].toDate().hour}', style: TextStyle(fontSize: 15, color: Colors.black54, height: 0.8,),textAlign: TextAlign.center,),
                        ],
                      ),
                      ],

                    ),
                  ),

                  Expanded(
                    flex : 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          
                        Text('${getDayName(listaViajes[0]['fecha'].toDate().weekday)} ${listaViajes[0]['fecha'].toDate().day}', style: TextStyle(fontSize: 18, color: Colors.black, height: 2.5),textAlign: TextAlign.center,),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Text('${listaViajes[0]['fecha'].toDate().hour}', style: TextStyle(fontSize: 15, color: Colors.black54, height: 0.8,),textAlign: TextAlign.center,),
                        ],
                      ),
                      ],

                    ),),]),),
                    onTap: () {print('Has seleccionado un viaje');},
                    );
                           
  } );
  }

    String getDayName(int day) {
      String res = '';
      switch(day) {
        case 1:
          res = 'LUN';
        break;

        case 2:
          res = 'MAR';
        break;

        case 3:
          res = 'MIE';
        break;

        case 4:
          res = 'JUE';
        break;

        case 5:
          res = 'VIE';
        break;

        case 6:
          res = 'SAB';
        break;

        case 7:
          res = 'DOM';
        break;
      }
      return res;
    }

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

  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Buscar Viaje"),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
          backgroundColor: TransportifyColors.primarySwatch,
          body: Padding(
          padding: EdgeInsets.only(left:15.0, right: 15.0),
          child: Column(
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
                      visibilityList = false; listaViajes.clear(); 
                      return 'Introduzca los puntos origen y destino';
                      
                    }
                    else if (puntoDestino.id == puntoOrigen.id){
                      visibilityList = false; listaViajes.clear();
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
                              textoNViajes = new Text(
                                '${viajesEncontrados}',
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
                  child: sacarListaViajes(),
                ),) : new Container(),
             
                ],
                ),
              ),
              ),
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