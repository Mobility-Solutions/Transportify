import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transportify/middleware/PaqueteBD.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';

import '../../util/style.dart';
import 'CustomStepper.dart';

class SeguimientoForm extends UserDependantStatelessWidget {
  SeguimientoForm(Usuario usuario) : super(usuario);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text("Seguimiento"),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
        body: Center(child: PaqueteBD.obtenerListadoPaquetesWidget(usuario: usuario, onSelected: obtenerFuncionVerSeguimiento(context))));
  }

  Function(int) obtenerFuncionVerSeguimiento(BuildContext context) {
    return (estado) => _verSeguimiento(context, estado);
  }

  void _verSeguimiento(BuildContext context, int estado) {
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
  int progreso = 0;
  static DateTime fechaEntregaPaquete = DateTime(2019, 12, 5);
  static DateTime fechaActual = DateTime.now();
  int diferencia = fechaEntregaPaquete.difference(fechaActual).inDays;
  var porcentajeController = TextEditingController();

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
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
        body: new Container(
            child: Column(
              children: <Widget>[
                new CustomStepper(
                  steps: spr,
                  type: CustomStepperType.vertical,
                  currentStep: _currentstep,
                  onStepContinue: null,
                  onStepCancel: null,
                  onStepTapped: null,
                ),

                TextFormField(
                    controller: porcentajeController,
                    enabled: false,
                    autofocus: false,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TransportifyColors.primarySwatch),
                    decoration: InputDecoration.collapsed(
                      hintStyle: TextStyle(color: TransportifyColors.primarySwatch, fontSize: 16, fontWeight: FontWeight.bold),
                      hintText: 'ESTIMACIÓN DEL PROGRESO DEL PAQUETE: ' + getPorcentaje().toString() + "%",
                    ),
                  ),

              ],
            ),
        ),
    );
  }

  int getPorcentaje() {
    progreso = (((daysIn(forYear: fechaEntregaPaquete.year, month: fechaEntregaPaquete.month) + fechaEntregaPaquete.day)*100) ~/ (daysIn(forYear: fechaActual.year, month: fechaActual.month) + fechaActual.day));
    //print((((daysIn(forYear: fechaEntregaPaquete.year, month: fechaEntregaPaquete.month) + fechaEntregaPaquete.day)*100) ~/ (daysIn(forYear: fechaActual.year, month: fechaActual.month) + fechaActual.day)).toString());
    if(progreso <= 0) {
      setState(() {
        progreso = 0;
        _setStep(1);
      });
    } else if(progreso >= 25) {
      setState(() {
        _setStep(2);
      });
    }
    if(progreso >= 100) {
      setState(() {
        progreso = 100;
        _setStep(3);
      });
    }

    return progreso;
  }

  int daysIn({int month, int forYear}){
    DateTime firstOfNextMonth;
    if(month == 12) {
      firstOfNextMonth = DateTime(forYear+1, 1, 1, 12);//year, month, day, hour
    }
    else {
      firstOfNextMonth = DateTime(forYear, month+1, 1, 12);
    }
    int numberOfDaysInMonth = firstOfNextMonth.subtract(Duration(days: 1)).day;
    //.subtract(Duration) returns a DateTime, .day gets the integer for the day of that DateTime
    return numberOfDaysInMonth;
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
