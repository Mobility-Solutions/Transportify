// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('BuscarPaquete Test', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    final ciudadOrigenFinder = find.byValueKey("ciudad_origen");
    final ciudadDestinoFinder = find.byValueKey("ciudad_destino");
    final fechaTextFinder = find.byValueKey('fecha_entrega');
    final horaTextFinder = find.byValueKey('hora_entrega');
    final buscarBotonFinder = find.byValueKey('buscar');
    

    FlutterDriver driver;

    setUpAll(() async{
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Flutter drive methods demo', () async {

      await driver.tap(find.byValueKey('input_email'));
      await driver.enterText('alcisande@entrepeneur.org');
      await driver.tap(find.byValueKey('input_password'));
      await driver.enterText('sandemetrio',timeout: Duration(seconds: 5));
      await driver.tap(find.byValueKey('button_login'));
    });

    test('BuscarPaquete', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await driver.waitFor(find.byValueKey('buscar_paquete'));
      await driver.tap(find.byValueKey('buscar_paquete'));

      await driver.waitFor(ciudadOrigenFinder);
      await driver.tap(ciudadOrigenFinder);
      //await driver.tap(find.byValueKey('ciudad'));
      await driver.tap(find.text('Valencia'));
      //await driver.tap(find.byValueKey('ciudad'));
      await driver.tap(find.text('OK'));

      await driver.waitFor(ciudadDestinoFinder);
      await driver.tap(ciudadDestinoFinder);
      //await driver.tap(find.byValueKey('ciudad'));
      await driver.tap(find.text('Madrid'));
      await driver.tap(find.text('OK'));

      await driver.waitFor(fechaTextFinder);
      await driver.scroll(fechaTextFinder,0,0,Duration(seconds: 1));
      await driver.enterText('21/12/19');

      await driver.waitFor(horaTextFinder);
      await driver.scroll(horaTextFinder,0,0,Duration(seconds: 1));
      await driver.enterText('08:50');

      await driver.waitFor(buscarBotonFinder);
      await driver.tap(buscarBotonFinder);
      /*
      final listFinder = find.byValueKey('listaViajes');
      final viajeBuscadoFinder = find.byValueKey("cargaViaje");
      final timeline = await driver.traceAction(() async {
        await driver.scrollUntilVisible(
          listFinder,
          viajeBuscadoFinder,
          dyScroll: -300.0,
        );

        expect(await driver.getText(viajeBuscadoFinder), "8.0 kg");
        
      });


      final summary = new TimelineSummary.summarize(timeline);

      summary.writeSummaryToFile('scrolling_summary', pretty: true);

      summary.writeTimelineToFile('scrolling_timeline', pretty: true);*/
    });


  });
}