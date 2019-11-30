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

  CameraPosition _initialPosition = CameraPosition(target: LatLng(26.8206, 30.8025));
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
        body: Center(
          child: Stack(
            children: <Widget>[
              GoogleMap(    
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialPosition,
              ),
              
            ],
          ),
        ),
        bottomNavigationBar: new Stack(
          overflow: Overflow.visible,
          alignment: new FractionalOffset(5, 0.5),
          children: [
                new Container(
                    height: 80.0, color: TransportifyColors.primarySwatch),
                new Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TransportifyFormButton(
                        text: 'Cancelar',
                        onPressed: () {
                          
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
          ],
        ));
  }


}