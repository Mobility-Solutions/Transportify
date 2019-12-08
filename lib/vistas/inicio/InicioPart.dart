import 'package:flutter/material.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/vistas/inicio/Inicio.dart';

class InicioPartItem extends StatelessWidget {
  final Icon icono;
  final double spacing;
  final String texto;

  InicioPartItem({this.icono, this.spacing = 10.0, this.texto = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icono ?? const SizedBox(),
        SizedBox(width: spacing),
        Flexible(
          child: Wrap(
            direction: Axis.horizontal,
            spacing: spacing,
            children: <Widget>[
              Text(
                texto,
                style: TextStyle(fontSize: 20.0, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InicioPartItemConGestureDetector extends InicioPartItem {
  final Function() onTap;

  InicioPartItemConGestureDetector(
      {Icon icono, double spacing = 10.0, String texto = "", this.onTap})
      : super(
          icono: icono,
          spacing: spacing,
          texto: texto,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: super.build(context),
    );
  }
}

class InicioPart extends UserDependantStatelessWidget {
  final String titulo;
  final List<InicioPartItem> elementos;
  final double spacingEntreTituloYElementos;
  final Widget dato;

  final Color colorExterior, colorInterior;

  InicioPart({
    Usuario usuario,
    this.titulo,
    this.elementos = const [],
    this.dato = const SizedBox(),
    this.colorInterior,
    this.colorExterior,
    this.spacingEntreTituloYElementos = 5.0,
  }) : super(usuario);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorExterior,
      child: Material(
        color: colorInterior,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo ?? "",
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: spacingEntreTituloYElementos),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: elementos,
              ),
              SizedBox(height: 10.0),
              dato,
            ],
          ),
        ),
      ),
    );
  }
}
