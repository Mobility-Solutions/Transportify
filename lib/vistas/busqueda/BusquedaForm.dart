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
  final List<R> listaResultados = List<R>();
  bool comenzarBusqueda = false, validada = false, buscando = false;

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
    if (comenzarBusqueda) {
      buscando = true;
      Future<Widget> busqueda = Firestore.instance
          .collection(coleccionBD)
          .getDocuments()
          .then(_obtenerListaResultados);

      return FutureBuilder<Widget>(
          future: busqueda,
          builder: (context, widget) {
            return widget.hasData
                ? widget.data
                : _buildContainerBusqueda(false);
          });
    } else {
      return _buildContainerBusqueda(validada);
    }
  }

  Widget _obtenerListaResultados(QuerySnapshot snapshot) {
    Future<bool> hasData = buscar(context, snapshot);
    return FutureBuilder<bool>(
      future: hasData,
      builder: (context, busquedaHasData) {
        bool hasData;
        bool terminado =
            busquedaHasData.connectionState == ConnectionState.done;
        if (terminado) {
          hasData = busquedaHasData.data ?? false;
          buscando = false;
          comenzarBusqueda = false;
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
        Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10.0,
            children: [
              Text(
                '$textoResultados:',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              validada
                  ? Text(
                      '$resultados',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  : const SizedBox(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: TransportifyColors.primarySwatch[900],
                ),
                child: IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  // Pasar un onPressed null pone el botón en disabled
                  onPressed: buscando
                      ? null
                      : () {
                          setState(() {
                            validada = _formKey.currentState.validate();
                            comenzarBusqueda = validada;
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
      itemCount: resultados,
      itemBuilder: builderListado,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget builderListado(BuildContext context, int index);
}
