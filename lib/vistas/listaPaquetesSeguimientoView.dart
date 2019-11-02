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
