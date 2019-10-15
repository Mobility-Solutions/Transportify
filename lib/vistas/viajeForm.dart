import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';



class MyViajeForm extends StatefulWidget {
  
  MyViajeForm({Key key, this.title}) : super(key: key);
  @override
  _MyViajeFormState createState() => _MyViajeFormState();

  final String title;
}

class _MyViajeFormState extends State<MyViajeForm> {

    String _date = "Not set";
    String _time = "Not set";
    String _originPoint = "Not set";
    String _destinationPoint = "Not set";

  @override 
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      
      appBar: AppBar(
        title: Text("Publicar un Viaje"),
        backgroundColor: Colors.blue[700],
        elevation: 0.0
      ),
      body: Padding(
        padding: EdgeInsets.only(left:14.0, right: 14.0),
        child: Container (
          child: Column(
            
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              /** 
               * **************************
               * SELECTOR DE PUNTO ORIGEN *
               * **************************
               * */
               SizedBox(
                height: 50.0,
              ),
              RaisedButton(
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
                //elevation: 4.0,
                color: Colors.white,
                //child: new Text('Selecciona fecha'),
                onPressed: () {
                  
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text( 
                        "Punto de Origen",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      ),
                      Icon( 
                        Icons.location_on,
                        size: 20.0,
                        color: Colors.blue[800],
                      ),
                    ],
                  ),
                ), 
              ),
              SizedBox(
                height: 20.0,
              ),
              /** 
               * ***************************
               * SELECTOR DE PUNTO DESTINO *
               * ***************************
               * */
              RaisedButton(
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
                //elevation: 4.0,
                color: Colors.white,
                //child: new Text('Selecciona fecha'),
                onPressed: () {
                  
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text( 
                        "Punto de Destino ",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      ),
                      Icon( 
                        Icons.location_on,
                        size: 20.0,
                        color: Colors.blue[800],
                      ),
                    ],
                  ),
                ), 
              ),
              SizedBox(
                height: 20.0,
              ),

              /** 
               * *******************
               * SELECTOR DE FECHA *
               * *******************
               * */
              RaisedButton(
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
                //elevation: 4.0,
                color: Colors.white,
                //child: new Text('Selecciona fecha'),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                    theme: DatePickerTheme(
                      containerHeight: 200.0,
                    ),
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: new DateTime(DateTime.now().year + 3),
                    //onChanged: (date) {print ('change $date');},
                    onConfirm: (date) {
                      print ('confirm $date');
                      _date = '${date.year} - ${date.month} - ${date.day}';
                      setState(() {});
                    },
                    currentTime: DateTime.now(), 
                    locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon( 
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.blue[800],
                                ),
                                Text(
                                  "  $_date",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text( 
                        " Cambiar",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                      ),
                    ],
                  ),
                ), 
              ),
              SizedBox(
                height: 20.0,
              ),
              /** 
               * ******************
               * SELECTOR DE HORA *
               * ******************
               * */
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                //elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(
                    context,
                      theme: DatePickerTheme(
                        containerHeight: 200.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    print('confirm $time');
                    _time = '${time.hour} : ${time.minute}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.blue[800],
                                ),
                                Text(
                                  "  $_time",
                                  style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Cambiar",
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 100.0,
              ),
              /** 
               * ******************
               * BOTÓN DE ACEPTAR *
               * ******************
               * */
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                //elevation: 4.0,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      Text(
                        "ACEPTAR",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.indigo[800],
              )
            ],
          ),
        ),
        
      ),

      backgroundColor: Colors.blue[700],
    );
  }

    





  }
