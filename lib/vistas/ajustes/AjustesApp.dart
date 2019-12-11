import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportify/modelos/Usuario.dart';
import 'package:transportify/util/style.dart';
import 'package:permission_handler/permission_handler.dart';

class AjustesApp extends StatefulWidget {
  @override
  AjustesAppState createState() => AjustesAppState();

  AjustesApp(this.usuario) : super();

  final Usuario usuario;
}

class AjustesAppState extends State<AjustesApp> {
  final _formKey = GlobalKey<FormState>();

  bool permisoUbicacion;
  bool permisoNotificacion;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajustes"),
          backgroundColor: TransportifyColors.primarySwatch,
          elevation: 0.0,
        ),
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0, top: 15.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Permisos",
                      style: TextStyle(
                          color: TransportifyColors.primarySwatch,
                          fontSize: 30,
                          fontWeight: FontWeight.w900)),
                  Divider(height: 5, color: TransportifyColors.primarySwatch),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.gps_fixed,
                          color: TransportifyColors.primarySwatch),
                      Text(" GPS",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900)),
                      Switch(
                        value: permisoUbicacion,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              getPermisoUbicacion();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.add_alert,
                          color: TransportifyColors.primarySwatch),
                      Text(" Notificaciones",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900)),
                      Switch(
                        value: permisoNotificacion,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              getPermisoNotificacion();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await getPermisos(PermissionGroup.location);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> getPermisos(PermissionGroup permissionGroup) async {
    Map<PermissionGroup, PermissionStatus> permisos =
        await PermissionHandler().requestPermissions([permissionGroup]);
    if (permisos[permissionGroup] == PermissionStatus.granted) {
      return true;
    }

    return false;
  }

  Future<bool> getPermisoUbicacion() async {
    return getPermisos(PermissionGroup.location);
  }

  Future<bool> getPermisoNotificacion() async {
    return getPermisos(PermissionGroup.notification);
  }

  Future<bool> hasPermisos(PermissionGroup permissionGroup) async {
    var permisosStatus =
        await PermissionHandler().checkPermissionStatus(permissionGroup);
    return permisosStatus == PermissionStatus.granted;
  }

  Future<bool> hasPermisoUbicacion() async {
    return hasPermisos(PermissionGroup.location);
  }

  Future<bool> hasPermisoNotificacion() async {
    return hasPermisos(PermissionGroup.notification);
  }

  @override
  void initState() {
    hasPermisoNotificacion().then((value) {
      setState(() {
        permisoNotificacion = value;
      });
    });
    hasPermisoUbicacion().then((value) {
      setState(() {
        permisoNotificacion = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
