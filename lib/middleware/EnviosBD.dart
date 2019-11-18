// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:transportify/middleware/Datos.dart';
// import 'package:transportify/modelos/Envio.dart';
// import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';

// class EnviosBD {
//   static const String coleccion_envios = 'envios';

//   static const String atributo_estado = 'estado';
//   static const String atributo_paquete = 'paquete';
//   static const String atributo_viaje = 'viaje';

//   static EstadoPaquete obtenerEstado(DocumentSnapshot snapshot) =>
//       EstadoPaquete.values[snapshot[atributo_estado]];
//   static DocumentReference obtenerPaquete(DocumentSnapshot snapshot) =>
//       snapshot[atributo_paquete];
//   static DocumentReference obtenerViaje(DocumentSnapshot snapshot) =>
//       snapshot[atributo_viaje];

//   static Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
//       _obtenerListaEnviosBuilder(Function(int estado) onTapMethod) =>
//           (context, snapshot) =>
//               _obtenerListaEnvios(context, snapshot, onTapMethod);

//   static Widget _obtenerListaEnvios(BuildContext context,
//       AsyncSnapshot<dynamic> snapshot, onTapMethod(int estado)) {
//     if (!snapshot.hasData) return const Text('Cargando...');

//     return ListView.builder(
//       itemBuilder: (context, index) {
//         List<DocumentSnapshot> documents = snapshot.data.documents;
//         if (index >= 0 && index < documents.length) {
//           Envio envio = Envio.fromSnapshot(documents[index]);
//           return FutureBuilder(
//             future: envio.waitForInit(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return ListTile(
//                   title: Text(envio.paquete.nombre),
//                   onTap: () => onTapMethod(envio.estado.index),
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           );
//         } else {
//           return null;
//         }
//       },
//     );
//   }

//   static Widget obtenerListaEnvios(Function(int estado) onTapMethod) {
//     var builder = _obtenerListaEnviosBuilder(onTapMethod);
//     return Datos.obtenerStreamBuilderCollectionBD(coleccion_envios, builder);
//   }
// }
