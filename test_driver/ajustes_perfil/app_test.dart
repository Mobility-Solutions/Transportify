import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:transportify/Keys.dart';

import '../TestingGlobals.dart';

//import '../TestingGlobals.dart';

void main() {
  group('AjustesPerfil Test', () {
    FlutterDriver driver;
    //var usuarioInicial, usuario;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      //usuarioInicial = await TestingGlobals.obtenerUsuarioTesting();
      //usuario = await TestingGlobals.obtenerUsuarioTesting();
    });

    tearDownAll(() async {
      // Restaura los valores iniciales del usuario testing
      //await usuarioInicial.updateBD();

      if (driver != null) {
        driver.close();
      }
    });

    test("check flutter driver health", () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test("login", () async {
      final inputCorreoFinder = find.byValueKey(Keys.inputCorreo);
      await driver.waitFor(inputCorreoFinder);

      await driver.tap(inputCorreoFinder);
      await driver.enterText(TestingGlobals.user_correo);
      await driver.tap(find.byValueKey(Keys.inputPassword));
      await driver.enterText(TestingGlobals.user_password,
          timeout: Duration(seconds: 5));
      await driver.tap(find.byValueKey(Keys.loginButton));
    });

    test("open ventana perfil", () async {
      final ajustesPerfilButtonFinder = find.byValueKey(Keys.ajustesPerfil);

      await driver.waitFor(ajustesPerfilButtonFinder);
      await driver.tap(ajustesPerfilButtonFinder);
    });

    // test("Fields with user data on init.", () async {
    //   await usuario.waitForInit();
    //   expect(await driver.getText(nombreTextFinder), usuario.nombre);
    //   expect(await driver.getText(correoTextFinder), usuario.correo);
    //   expect(await driver.getText(ciudadTextFinder), usuario.ciudad);
    //   expect(await driver.getText(edadTextFinder), usuario.edad);
    // });

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

      final selectorCiudadesFinder = find.byValueKey(Keys.selectorCiudadesListView);
      await driver.waitFor(selectorCiudadesFinder);

      final nuevaCiudadEnSelectorFinder = find.descendant(of: selectorCiudadesFinder, matching: find.text(nuevaCiudad));
      await driver.scrollUntilVisible(selectorCiudadesFinder, nuevaCiudadEnSelectorFinder, dyScroll: -300.0);
      await driver.tap(nuevaCiudadEnSelectorFinder);
      
      final selectorCiudadBotonAceptarFinder = find.byValueKey(Keys.acceptButton);
      await driver.tap(selectorCiudadBotonAceptarFinder);

      await driver.tap(edadTextFinder);

      const int nuevaEdad = 69;
      await driver.enterText(nuevaEdad.toString());

      await driver.tap(saveButtonFinder);

      // TODO: Comprobar valores BD sin importar implicitamente dart:ui

      // await usuario.revertToBD();

      // expect(usuario.nombre, nuevoNombre);
      // expect(usuario.correo, nuevoCorreo);
      // expect(usuario.ciudad, nuevaCiudad);
      // expect(usuario.edad, nuevaEdad);
    });
  });
}
