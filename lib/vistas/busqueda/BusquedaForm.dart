import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/util/style.dart';

abstract class BusquedaFormState<T extends StatefulWidget, R> extends State<T> {
  final String titulo;
  final String coleccionBD;
  final String textoResultados;

  BusquedaFormState({this.titulo, this.coleccionBD, this.textoResultados});

  int get resultados => listaResultados.length;
  List<R> listaResultados = List<R>();
  bool validada = false, buscando = false;

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

  Widget obtenerListaResultados() {
    if (validada) {
      buscando = true;
      Future<Widget> busqueda = Firestore.instance
          .collection(coleccionBD)
          .getDocuments()
          .then(_obtenerListaResultados);

      return FutureBuilder<Widget>(
          future: busqueda,
          builder: (context, widget) {
            return widget.hasData ? widget.data : _buildContainerBusqueda(false);
          });
    } else {
      validada = false;
      return _buildContainerBusqueda(false);
    }
  }

  Widget _obtenerListaResultados(QuerySnapshot snapshot) {
    Future<bool> hasData = buscar(context, snapshot);
    return FutureBuilder<bool>(
      future: hasData,
      builder: (context, busquedaHasData) {
        bool hasData;
        if (busquedaHasData.connectionState == ConnectionState.done) {
          hasData = busquedaHasData.data;
          buscando = false;
        } else {
          hasData = false;
        }
        return _buildContainerBusqueda(hasData);
      },
    );
  }

  Future<bool> buscar(BuildContext context, QuerySnapshot snapshot);

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
                  // Pasar un onPressed null pone el botón en disabled
                  onPressed: buscando ? null : () {
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
