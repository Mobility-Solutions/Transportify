import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/EnviosBD.dart';
import 'package:transportify/widgets/customStepper.dart';

int estado = -1;
class ListaPaquetesSeguimientoView extends StatefulWidget {
  @override
  _ListaPaquetesViewState createState() => new _ListaPaquetesViewState();  


}

class _ListaPaquetesViewState extends State<ListaPaquetesSeguimientoView>{
 @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body:Center(
        child: EnviosBD.obtenerListaEnvios(verSeguimiento)
    )
    
    );
  }

  void verSeguimiento(int est){
    estado = est;
    Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new SeguimientoView();
        }));
  }

}

class SeguimientoView extends StatefulWidget {
  @override
  _SeguimientoViewState createState() => new _SeguimientoViewState();
}

class _SeguimientoViewState extends State<SeguimientoView> {

  int _currentstep = 0;

  void _setStep(int s) {
    _currentstep = s;
  }


  @override
  Widget build(BuildContext context) {
    _setStep(estado);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Seguimiento"),
        ),
        body: new Container(
            child:
            new CustomStepper(steps: spr, type: CustomStepperType.vertical, currentStep: _currentstep, onStepContinue: null, onStepCancel: null,
              onStepTapped: null,)
        )
    );
  }
}

const List<CustomStep> spr = <CustomStep>[
  // const Step( title:  ,'SubTitle1', 'This is Content', state: StepState.indexed, true)
  CustomStep(title: const Text('Por recoger'), content: const Text('El paquete está esperando a ser recogido'), state: CustomStepState.indexed, isActive: true),
  CustomStep(title: const Text('En envio'), content: const Text('El paquete está en camino'), state: CustomStepState.indexed, isActive: true),
  CustomStep(title: const Text('Entregado'),  content: const Text('El paquete ya ha sido entregado'), state: CustomStepState.indexed, isActive: true),
];





/*

class EnviosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('mountains').snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new ListTile(
              title: new Text(document['title']),
              subtitle: new Text(document['type']),
            );
          }).toList(),
        );
      },
    );
  }



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

  static StreamBuilder obtenerStreamBuilder_Envios(Function(BuildContext, AsyncSnapshot<dynamic>) builder) {
    //Junta el buildesr con un flujo de datos
    return StreamBuilder(
        stream: Firestore.instance.collection('envios')
            .snapshots(),
        builder: builder
    );
    */

   

//}
