import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/modelos/enumerados/EstadoActividad.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/vistas/actividad/MiActividadBusqueda.dart';

class MiActividadView extends StatefulWidget {
  final Usuario usuario;

  MiActividadView(this.usuario) : super();

  @override
  _MiActividadViewState createState() => _MiActividadViewState();
}

class _MiActividadViewState extends State<MiActividadView> {
  Map<String, bool> _categoryExpansionStateMap = Map<String, bool>();
  bool isExpanded;

  @override
  void initState() {
    super.initState();

    _categoryExpansionStateMap = {
      "Publicados": false,
      "En Curso": false,
      "Finalizados": false,
    };

    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mi Actividad'),
          backgroundColor: TransportifyColors.primarySwatch,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _categoryExpansionStateMap[_categoryExpansionStateMap.keys
                          .toList()[index]] = !isExpanded;
                    });
                  },
                  children: <ExpansionPanel>[
                    ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: Icon(
                              Icons.new_releases,
                              color: TransportifyColors.primarySwatch,
                            ),
                            title: Text("Publicados",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: TransportifyColors.primarySwatch)),
                          );
                        },
                        body: MiActividadBusqueda(
                            EstadoActividad.PUBLICADO, widget.usuario),
                        isExpanded: _categoryExpansionStateMap["Publicados"]),
                    ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              leading: Icon(
                                Icons.sync,
                                color: Colors.pink,
                              ),
                              title: Text("En Curso",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.pink)));
                        },
                        body: MiActividadBusqueda(
                            EstadoActividad.PUBLICADO, widget.usuario),
                        isExpanded: _categoryExpansionStateMap["En Curso"]),
                    ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              leading: Icon(Icons.check_box,
                                  color: Colors.grey[500]),
                              title: Text("Finalizados",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.grey[500])));
                        },
                        body: MiActividadBusqueda(
                            EstadoActividad.PUBLICADO, widget.usuario),
                        isExpanded: _categoryExpansionStateMap["Finalizados"]),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
