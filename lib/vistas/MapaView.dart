import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportify/util/style.dart';

class MapaView extends StatefulWidget {
  MapaView([Key key]):super(key: key);
  @override
  _MapaViewState createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {

  CameraPosition _initialPosition = CameraPosition(target: LatLng(40.416775, 	-2.8), zoom: 5);
Completer<GoogleMapController> _controller = Completer();


void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Elegir ciudad/Punto Transportify'),
          backgroundColor: TransportifyColors.primarySwatch,
          centerTitle: true,
        ),
        body: Container(
          color: TransportifyColors.primarySwatch,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 250,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(    
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _initialPosition,
                ),
              ),
              SizedBox(
                height: 5.0
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15.0
                  ),
                  Text(
                    'Punto Seleccionado: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  )
              ),
                ],
              ),
            ],
          ),
        ),        
        extendBody: false,
        bottomNavigationBar: new Stack(
          overflow: Overflow.visible,
          alignment: new FractionalOffset(10, 0.5),
          children: [
                new Container(
                    height: 80.0, color: TransportifyColors.primarySwatch
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[ 
                    new Row(
                      children: <Widget>[                    
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TransportifyFormButton(
                            text: 'Cancelar',
                            onPressed: () {
                              Navigator.pop(context);
                            },),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TransportifyFormButton(
                            text: 'Guardar',
                            onPressed: () {
                              
                            },),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                ),
                  ]
                
              ),
          ],
        ));
  }


}