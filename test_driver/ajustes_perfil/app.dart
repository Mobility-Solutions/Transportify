import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'package:transportify/main.dart' as app;


void main() {
  // This line enables the extension
  enableFlutterDriverExtension();
  iniciar();
}

void iniciar() async =>
    await initializeDateFormatting("es_ES", null).then((_) => app.main());
