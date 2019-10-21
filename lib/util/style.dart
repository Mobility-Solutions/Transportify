import 'package:flutter/material.dart';

class TransportifyColors {
  static const String primaryValueString = "#3C6997";
  static const String primaryLightValueString = "#6D97C8";
  static const String primaryDarkValueString = "#2A4D70";

  static const int primaryValue = 0xff3C6997;
  static const int primaryLightValue = 0xff6D97C8;
  static const int primaryDarkValue = 0xff2a4d70;

  /*  
   * Color application palette.
   * Use it with TransportifyColors.primarySwatch[50-900]
  */
  static const MaterialColor primarySwatch = const MaterialColor(
    primaryValue,
    const <int, Color>{
      50: const Color(primaryLightValue), //#6D97C8
      100: const Color(0xff658FC0), //#658FC0
      200: const Color(0xff5D88B8), //#5D88B8
      300: const Color(0xff4C78A7), //#4C78A7
      400: const Color(0xff44719F), //#44719F
      500: const Color(primaryValue), //#3C6997
      600: const Color(0xff38628D), //#38628D
      700: const Color(0xff335B84), //#335B84
      800: const Color(0xff2F547A), //#2F547A
      900: const Color(primaryDarkValue), //#2A4D70
    },
  );

  // Components
  static const appBackground = Color(primaryValue);
  static const scaffoldBackground = Color(primaryValue);
}

class TransportifyContainer extends StatelessWidget {
  /*  
   * Default TransportifyContainer widget to store stuff
   * @param padding (by default 15.0), to add margins between other components.
   * @param child To save components on the widget.
   * @param color (by default #3C6997), to color the custom container.
   * @param vertical (by default true), to set padding vertical or horizontal (useful for rows and columns).
  */

  TransportifyContainer(
      {this.child,
      this.padding = 15.0,
      this.color = TransportifyColors.primarySwatch,
      this.vertical = true});

  final double padding;
  final Widget child;
  final Color color;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: vertical
            ? EdgeInsets.symmetric(vertical: padding)
            : EdgeInsets.symmetric(horizontal: padding),
        child: child);
  }
}

/*  
   * Default Button widget for forms.
   * @param text To name the button.
   * @param onPressed Callback .
*/

class TransportifyFormButton extends StatelessWidget {
  final GestureTapCallback onPresed;
  final String text;

  TransportifyFormButton({@required this.onPresed, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPresed,
      child: Container(
        height: 56.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: TransportifyColors.primarySwatch[900]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}

class TransportifyMethods {
  /*
  * Shows a custom dialog to return to the previous screen.
  * @param _context widget's context
  * @param _title dialog's title
  * @param content (optional) show a message with the details
  * @Param buttonMessage (optional) by default "CERRAR"
  */
  static doneDialog(BuildContext _context,String _title,{String content,String buttonMessage}) async {
    await showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: Text(_title),
        content: Text(content),
        actions: [
          new FlatButton(
            child: new Text(buttonMessage !=null ? buttonMessage : "CERRAR" ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    Navigator.pop(_context);
  }

  static InputDecoration returnTextFormDecoration(String hintText) {
    return InputDecoration(
      suffixIcon: hintText.startsWith("Punto") ? Icon(Icons.location_on) : null,
      hintText: hintText,
      hintStyle: TextStyle(color: TransportifyColors.primarySwatch),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}

/*
 * Labels to put directly into the app. 
 */
class TransportifyLabels {
  //Strings
  static const String appname = "Transportify";
  static const String nuevoPaquete = "Nuevo Paquete";
  static const String nuevoViaje = "Nuevo Viaje";
  static const String seguimientoPaquete = "Seguimiento";
  static const String buscarPaquete = "Buscar Paquete";
  static const String inicio = "Inicio";
}
