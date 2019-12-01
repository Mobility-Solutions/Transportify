import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Usuario.dart';

class MiActividadView extends StatefulWidget {
  final Usuario usuario;

  MiActividadView(this.usuario) : super();
  
    @override
  _MiActividadViewState createState() => _MiActividadViewState();
}

class _MiActividadViewState extends State<MiActividadView>{
  Widget listaPaquetes;
  Widget listaViajes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Actividad'),
      ),
      backgroundColor: Colors.white,
      body: ActividadDetails(widget: widget)
    );
  }
}

class ActividadDetails extends StatefulWidget {
  const ActividadDetails({
    Key key,
    @required this.widget,
  }) : super(key:key);

  final MiActividadView widget;

  @override
  _ActividadDetailsState createState() => _ActividadDetailsState();
}

class _ActividadDetailsState extends State<ActividadDetails> {
  Map<String, bool> _categoryExpansionStateMap = Map<String, bool>();
  bool isExpanded;

  @override
  void initState(){
    super.initState();

    _categoryExpansionStateMap = {
      "Publicados":false,
      "En Curso":false,
      "Finalizados":false,
    };

    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _categoryExpansionStateMap[_categoryExpansionStateMap.keys.toList()[index]] = !isExpanded;
                });
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded){
                    return ListTile(
                      title: Text(
                        "Publicados",
                        style:TextStyle(fontWeight: FontWeight.w500)
                      )
                    );
                  },
                    body: Publicados(),
                    isExpanded: _categoryExpansionStateMap["Publicados"]
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded){
                    return ListTile(
                      title: Text(
                        "En Curso",
                        style:TextStyle(fontWeight: FontWeight.w500)
                      )
                    );
                  },
                    body: Publicados(),
                    isExpanded: _categoryExpansionStateMap["En Curso"]
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded){
                    return ListTile(
                      title: Text(
                        "Finalizados",
                        style:TextStyle(fontWeight: FontWeight.w500)
                      )
                    );
                  },
                    body: Publicados(),
                    isExpanded: _categoryExpansionStateMap["Finalizados"]
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Publicados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return null;
  }
}