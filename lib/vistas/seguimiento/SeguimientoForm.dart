import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/PaqueteBD.dart';

import 'CustomStepper.dart';

class SeguimientoForm extends StatefulWidget {
  @override
  _SeguimientoFormState createState() => new _SeguimientoFormState();
}

class _SeguimientoFormState extends State<SeguimientoForm> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text("Seguimiento"),
        ),
        body: Center(child: PaqueteBD.obtenerListaPaquetes(verSeguimiento)));
  }

  void verSeguimiento(int estado) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new SeguimientoView(estado);
    }));
  }
}

class SeguimientoView extends StatefulWidget {
  final int estado;

  SeguimientoView(this.estado);
  
  @override
  _SeguimientoViewState createState() => new _SeguimientoViewState(estado);
}

class _SeguimientoViewState extends State<SeguimientoView> {
  int estado;
  int _currentstep = 0;

  _SeguimientoViewState(this.estado);

  void _setStep(int s) {
    _currentstep = s;
  }

  @override
  Widget build(BuildContext context) {
    _setStep(estado);
    return new Scaffold(
        appBar: new AppBar(
          title: const Text("Seguimiento"),
        ),
        body: new Container(
            child: new CustomStepper(
          steps: spr,
          type: CustomStepperType.vertical,
          currentStep: _currentstep,
          onStepContinue: null,
          onStepCancel: null,
          onStepTapped: null,
        )));
  }
}

const List<CustomStep> spr = <CustomStep>[
  // const Step( title:  ,'SubTitle1', 'This is Content', state: StepState.indexed, true)
  CustomStep(
      title: const Text('Por recoger'),
      content: const Text('El paquete está esperando a ser recogido'),
      state: CustomStepState.indexed,
      isActive: true),
  CustomStep(
      title: const Text('En envio'),
      content: const Text('El paquete está en camino'),
      state: CustomStepState.indexed,
      isActive: true),
  CustomStep(
      title: const Text('Entregado'),
      content: const Text('El paquete ya ha sido entregado'),
      state: CustomStepState.indexed,
      isActive: true),
];
