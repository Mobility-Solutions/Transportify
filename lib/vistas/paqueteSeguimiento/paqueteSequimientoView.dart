import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/widgets/customStepper.dart';
import 'package:transportify/widgets/customStepper.dart' as prefix0;

class SeguimientoView extends StatefulWidget {
  @override
  SeguimientoView({Key key, this.title}) : super(key: key);
  final String title;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seguimiento"),
      ),
    );


  }

  @override
  _SeguimientoViewState createState() => new _SeguimientoViewState();
}
/*
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

 */

class _SeguimientoViewState extends State<SeguimientoView> {

  int _currentstep = 0;
  void _movetonext() {
    setState(() {
      _currentstep++;
    });
  }

  void _movetostart() {
    setState(() {
      _currentstep = 0;
    });
  }

  void _showcontent(int s) {
    setState(() {
      _currentstep = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Tittle"),
        ),
        body: new Container(
            child:
            new CustomStepper(steps: spr, type: prefix0.CustomStepperType.vertical, currentStep: _currentstep, onStepContinue: _movetonext, onStepCancel: _movetostart,
              onStepTapped: _showcontent,)
        )
    );
  }
}

const List<CustomStep> spr = <CustomStep>[
  // const Step( title:  ,'SubTitle1', 'This is Content', state: StepState.indexed, true)
  CustomStep(title: const Text('Por recoger'), subtitle: Text('SubTitle1'), content: const Text('This is Content1'), state: CustomStepState.indexed, isActive: true),
  CustomStep(title: const Text('En envio'), subtitle: Text('SubTitle2'), content: const Text('This is Content2'), state: CustomStepState.indexed, isActive: true),
  CustomStep(title: const Text('Entregado'), subtitle: Text('SubTitle3'), content: const Text('This is Content3'), state: CustomStepState.indexed, isActive: true),
];
