

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Flutter Driver demo', ()
  {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test('Flutter drive methods demo', () async {

      await driver.tap(find.byValueKey('input_email'));
      await driver.enterText('email@dominio.es');
      await driver.tap(find.byValueKey('input_password'));
      await driver.enterText('1111',timeout: Duration(seconds: 5));
      await driver.screenshot();

      //await driver.waitFor(find.text('Scroll till here'));




      /*
      await driver.waitFor(find.text('Hello !'));
      await driver.enterText('World');
      await driver.waitForAbsent(find.text('Hello !'));
      print('World');
      await driver.waitFor(find.byValueKey('button'));
      await driver.tap(find.byValueKey('button'));
      print('Button clicked');
      await driver.waitFor(find.byValueKey('text'));
      await driver.scrollIntoView(find.byValueKey('text'));
      await driver.waitFor(find.text('Scroll till here'));
      print('I found you buddy !');

       */
    });

    test('Register', () async {
      await driver.tap(find.byValueKey('button_register'));

      await driver.waitFor(find.byValueKey('input_nickname'));

      await driver.tap(find.byValueKey('input_nickname'));
      await driver.enterText('Nick');

      await driver.tap(find.byValueKey('input_name'));
      await driver.enterText('Alba Ricoque');


      await driver.tap(find.byValueKey('input_email'));
      await driver.enterText('email@dominio.es');

      await driver.tap(find.byValueKey('input_password'));
      await driver.enterText('1111');

      await driver.tap(find.byValueKey('select_city'));
      await driver.tap(find.text('Valencia'));
      await driver.tap(find.text('OK'));

      await driver.tap(find.byValueKey('input_age'));
      await driver.enterText('19');

      await driver.tap(find.byValueKey('button_registrarse'));

      await driver.waitFor(find.text("ACTIVIDAD"));

    });

  });

}