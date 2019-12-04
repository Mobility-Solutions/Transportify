import 'package:flutter_driver/flutter_driver.dart';
import 'package:transportify/Keys.dart';

class TestingGlobals {
  static const String user_uid = "_testing_",
      user_correo = 'testing@testing.com',
      user_password = 'testing';

  static Future<void> login(FlutterDriver driver) async {
    final inputCorreoFinder = find.byValueKey(Keys.inputCorreo);
    await driver.waitFor(inputCorreoFinder);

    await driver.tap(inputCorreoFinder);
    await driver.enterText(TestingGlobals.user_correo);
    await driver.tap(find.byValueKey(Keys.inputPassword));
    await driver.enterText(TestingGlobals.user_password,
        timeout: Duration(seconds: 5));
    await driver.tap(find.byValueKey(Keys.loginButton));
  }

  static Future<void> seleccionarCiudad(
      FlutterDriver driver, String nuevaCiudad) async {
    final selectorCiudadesFinder =
        find.byValueKey(Keys.selectorCiudadesListView);
    await driver.waitFor(selectorCiudadesFinder);

    final nuevaCiudadEnSelectorFinder = find.descendant(
        of: selectorCiudadesFinder, matching: find.text(nuevaCiudad));
    await driver.scrollUntilVisible(
        selectorCiudadesFinder, nuevaCiudadEnSelectorFinder,
        dyScroll: -300.0);
    await driver.tap(nuevaCiudadEnSelectorFinder);

    final selectorCiudadBotonAceptarFinder = find.byValueKey(Keys.acceptButton);
    await driver.tap(selectorCiudadBotonAceptarFinder);
  }
}
