import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../modelos/Envio.dart';

class Datos{

  static StreamBuilder obtenerStreamBuilder_PuntosTransportify(Function(BuildContext, AsyncSnapshot<dynamic>) builder) {
    //Junta el buildesr con un flujo de datos
    return StreamBuilder(
        stream: Firestore.instance.collection('puntos_transportify')
            .snapshots(),
        builder: builder
    );
  }




}