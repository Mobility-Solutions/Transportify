import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:transportify/modelos/PuntoTransportify.dart';
import 'package:transportify/middleware/Datos.dart';


class myWidgets{

  /*DROPDOWN PUNTOS TRANSPORTIFY*/

  //Metodo principal



  //1
  static Widget obtenerDropDown({Function(dynamic) onChanged, dynamic value}) {
    //Se necesita un dropdown con un flujo de datos
    Function(BuildContext, AsyncSnapshot<QuerySnapshot>) dropDownBuilder = _obtenerDropDownBuilder(onChanged, value);
    var dropDownConStream = Datos.obtenerStreamBuilder_PuntosTransportify(dropDownBuilder);
    return dropDownConStream;
  }

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>) _obtenerDropDownBuilder(Function(dynamic) onChanged, dynamic value) {
    Function(BuildContext, AsyncSnapshot<dynamic>) dropDownBuilder =  (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //Metodo constructor del dropdown
      Widget dropDown;

      if (!snapshot.hasData) {
        dropDown = const Text('Cargando...');
      } else {
        List<DropdownMenuItem> items = new List<DropdownMenuItem>();
        for (DocumentSnapshot documentSnapshot in snapshot.data.documents) {
          PuntoTransportify punto = PuntoTransportify.fromSnapshot(documentSnapshot);
          DropdownMenuItem menuItem =
          DropdownMenuItem(
            child: Text(punto?.nombre ?? ""),
            value: punto,
          );

          items.add(menuItem);
        }

        dropDown = DropdownButton(
            items: items,
            onChanged: onChanged,
            value: value
        );
      }


      return dropDown;
    };
    return dropDownBuilder;
  }

}