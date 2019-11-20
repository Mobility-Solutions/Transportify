import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';
import 'package:transportify/middleware/Datos.dart';

abstract class BusquedaFormState<T extends StatefulWidget, R> extends State<T> {
  final String titulo;
  final String coleccionBD;
  final String textoResultados;

  BusquedaFormState({this.titulo, this.coleccionBD, this.textoResultados});

  int get resultados => listaResultados.length;
  List<R> listaResultados = List<R>();
  bool validada = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titulo),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
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
    return Datos.obtenerStreamBuilderCollectionBD(coleccionBD, builder);
  }

  Widget obtenerListaResultados() {
    return obtenerStreamBuilderListado(obtenerListaBuilder());
  }

  Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>)
      obtenerListaBuilder() {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      Future<bool> hasData;
      if (validada) {
        hasData = buscar(context, snapshot);
      } else {
        hasData = Future.value(false);
      }
      return FutureBuilder<bool>(
        future: hasData,
        builder: (context, hasData) =>
            _buildContainerBusqueda(hasData.hasData ? hasData.data : false),
      );
    };
  }

  Future<bool> buscar(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot);

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
                      validada
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
                      validada = _formKey.currentState.validate();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        validada
            ? Expanded(
                child: hasData
                    ? SizedBox.expand(
                        child: _buildListado(),
                      )
                    : const Center(child: const CircularProgressIndicator()),
              )
            : const SizedBox(),
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
