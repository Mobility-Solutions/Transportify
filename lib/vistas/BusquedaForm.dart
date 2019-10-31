import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/middleware/Datos.dart';

abstract class BusquedaFormState<T extends StatefulWidget> extends State<T> {
  final String titulo;
  final String atributoBD;
  final String textoResultados;

  BusquedaFormState({this.titulo, this.atributoBD, this.textoResultados});

  int get resultados => listaResultados.length;
  List<DocumentSnapshot> listaResultados = List<DocumentSnapshot>();
  bool listaVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titulo),
          backgroundColor: TransportifyColors.primarySwatch,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: [
              buildSelectorBusqueda(context),
              Expanded(
                child: SizedBox.expand(
                  child: obtenerListaResultados(),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: TransportifyColors.primarySwatch,
      ),
    );
  }

  Widget buildSelectorBusqueda(BuildContext context);

  StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(atributoBD, builder);
  }

  Widget obtenerListaResultados() {
    return obtenerStreamBuilderListado(obtenerListaBuilder());
  }

  Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      obtenerListaBuilder() {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      bool hasData = buscar(context, snapshot);
      if (!hasData) listaVisible = false;
      return _buildContainerBusqueda(hasData);
    };
  }

  bool buscar(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot);

  Widget _buildContainerBusqueda(bool hasData) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$textoResultados:  ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      listaVisible
                          ? Text(
                              '$resultados',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          : Container(),
                    ],
                  )),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: TransportifyColors.primarySwatch[900],
                ),
                child: IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      listaVisible = _formKey.currentState.validate();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        listaVisible
            ? Expanded(
                child: hasData
                    ? SizedBox.expand(
                        child: _buildListado(),
                      )
                    : const Text('Cargando...'),
              )
            : Container(),
      ],
    );
  }

  ListView _buildListado() {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      itemCount: resultados,
      itemBuilder: builderListado,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget builderListado(BuildContext context, int index);
}
