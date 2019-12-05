import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:transportify/modelos/Paquete.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/enumerados/EstadoPaquete.dart';
import 'package:transportify/util/style.dart';

class IncidenciasView extends StatefulWidget {
  @override
  IncidenciasViewState createState() => IncidenciasViewState();

  IncidenciasView(this.usuario, this.paquete) : super();

  final Usuario usuario;
  final Paquete paquete;

}

class IncidenciasViewState extends State<IncidenciasView> {
  
  final _formKey = GlobalKey<FormState>();
  var incidenciaController = TextEditingController();
  String comentario = "";
  int progreso, incidencias = 0, paqueteRetraso = 0;
  Color barraDeProgreso;

  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: _formKey,
      child: Scaffold(
        bottomNavigationBar: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: TransportifyColors.primarySwatch, width: 2), borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 60.0,
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextFormField(

                          validator: (value) {
                            if (value.isEmpty) {
                              return "Porfavor escriba su incidencia";
                            }
                            return null;
                          },
                          controller: incidenciaController,
                          decoration: InputDecoration.collapsed(
                            hintStyle: TextStyle(color: TransportifyColors.primarySwatch, fontSize: 17, fontWeight: FontWeight.w800),
                            hintText: "Escriba para añadir una incidencia...",
                          ),
                          onFieldSubmitted: (value) {
                            incidenciaController.text = value;
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.play_arrow, color: TransportifyColors.primarySwatch, size: 40),
                      ),
                      onTap: () {
                        setState(() {
                        if (_formKey.currentState.validate()) {
                          comentario = incidenciaController.text;
                          incidenciaController.text = "";
                          addIncidencia();
                        }
                        });
                      },
                    ),
                        ],
                      ),
                    ),
                  ],
        ),
        appBar: AppBar(
          title: Text("Seguimiento"),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: EdgeInsets.only(left:15.0, right: 15.0, bottom: 30.0, top: 15.0),
            child: Container (
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  Center(
                    child: CircularPercentIndicator(
                    animation: true,
                    radius: 180.0,
                    lineWidth: 15.0,
                    percent: getPorcentaje() / 100,
                    circularStrokeCap: CircularStrokeCap.round,
                    header: new Text(widget.paquete.nombre, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0)),
                    footer: Text(getEstadoPaquete(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Icon(
                          Icons.airport_shuttle,
                          size: 70.0,
                          color: TransportifyColors.primarySwatch,
                        ),

                        TextFormField(
                          enabled: false,
                          autofocus: false,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TransportifyColors.primarySwatch),
                          decoration: InputDecoration.collapsed(
                            hintStyle: TextStyle(color: TransportifyColors.primarySwatch, fontSize: 30, fontWeight: FontWeight.w900),
                            hintText: getPorcentaje().toString() + "%",
                          ),
                        ),
                      ],
                    ),
                backgroundColor: Colors.grey,
                progressColor: barraDeProgreso,
              ),
              ),

              SizedBox(
                height: 50,
              ),

              TextFormField(
                          enabled: false,
                          autofocus: false,
                          maxLines: 3,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: TransportifyColors.primarySwatch),
                          decoration: InputDecoration.collapsed(
                            hintStyle: TextStyle(color: TransportifyColors.primarySwatch, fontSize: 25, fontWeight: FontWeight.w800),
                            hintText: "Incidencias",
                          ),
              ),
              Expanded(
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.incidencias,
                    itemBuilder: (context, index) => 
                      addIncidencia(),
                ),
              ),
              ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  int getPorcentaje() {
    progreso = 100;
    barraDeProgreso = Colors.redAccent;
    widget.paquete.estado = EstadoPaquete.por_recoger;

    if(progreso <= 0) {
      setState(() {
        progreso = 0;
      });
    } else if(progreso >= 20 && progreso < 100) {
      setState(() {
        barraDeProgreso = Colors.orangeAccent;
        widget.paquete.estado = EstadoPaquete.en_envio;
      });
    } else if(progreso >= 100) {
      setState(() {
        progreso = 100;
        barraDeProgreso = Colors.greenAccent;
        widget.paquete.estado = EstadoPaquete.entregado;
      });
    }
    return progreso;
  }

  String getEstadoPaquete() {
    String estadoActual;
    switch(widget.paquete.estado) {
      case EstadoPaquete.en_envio:
        estadoActual = "Enviando...";
        break;
      case EstadoPaquete.entregado:
        estadoActual = "Entregado";
        break;
      case EstadoPaquete.por_recoger:
        estadoActual = "Por recoger";
        break;
      default:
        estadoActual = "";
        break;
    }
    return estadoActual;
  }

  ListTile addIncidencia() {
    this.incidencias += 1;

    return ListTile(
            leading: Icon(Icons.warning, color: TransportifyColors.primarySwatch),
            title: Text(comentario),
            subtitle: Text("El paquete se retrasará " + paqueteRetraso.toString() + " horas"),
          );
  }
}