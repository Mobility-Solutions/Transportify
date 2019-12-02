import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:transportify/Keys.dart';

import '../TestingGlobals.dart';

void main() {
  group('AjustesPerfil Test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("check flutter driver health", () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test("login", () async => await TestingGlobals.login(driver));

    test("open ventana perfil", () async {
      final ajustesPerfilButtonFinder = find.byValueKey(Keys.ajustesPerfil);

      await driver.waitFor(ajustesPerfilButtonFinder);
      await driver.tap(ajustesPerfilButtonFinder);
    });

    test("check modificacion perfil.", () async {
      final nombreTextFinder = find.byValueKey(Keys.inputNombre);
      final correoTextFinder = find.byValueKey(Keys.inputCorreo);
      final ciudadTextFinder = find.byValueKey(Keys.inputCiudad);
      final edadTextFinder = find.byValueKey(Keys.inputEdad);

      // TODO: Cuando PerfilUsuarioView contenga el nickname, añadir su testing
      final nicknameTextFinder = find.byValueKey(Keys.inputNickname);

      final editButtonFinder = find.byValueKey(Keys.editButton);
      final saveButtonFinder = find.byValueKey(Keys.saveButton);

      await driver.waitFor(editButtonFinder);
      await driver.tap(editButtonFinder);

      await driver.waitFor(nombreTextFinder);

      await driver.tap(nombreTextFinder);
      const String nuevoNombre = 'Test exitoso';
      await driver.enterText(nuevoNombre);

      await driver.tap(correoTextFinder);
      const String nuevoCorreo = 'testexitoso@testing.es';
      await driver.enterText(nuevoCorreo);

      await driver.tap(ciudadTextFinder);

      const String nuevaCiudad = 'Sevilla';
      await TestingGlobals.seleccionarCiudad(driver, nuevaCiudad);

      await driver.tap(edadTextFinder);
      const String nuevaEdad = '69';
      await driver.enterText(nuevaEdad);

      await driver.tap(saveButtonFinder);
    });
  });
}
