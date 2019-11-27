// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('BuscarViaje Test', () {
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

    test("Fields empty on init.",() async {
      expect(await driver.getText(ciudadOrigenFinder),"");
      expect(await driver.getText(ciudadDestinoFinder),"");
      expect(await driver.getText(fechaTextFinder),"");
      expect(await driver.getText(horaTextFinder),"");
    });

    test('BuscarViaje', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await driver.tap(ciudadOrigenFinder);
      await driver.tap(find.byValueKey('ciudad'));

      await driver.tap(ciudadDestinoFinder);
      await driver.tap(find.byValueKey('ciudad'));

      await driver.tap(fechaTextFinder);
      await driver.enterText('16/12/19');

      await driver.tap(horaTextFinder);
      await driver.enterText('01:00');

      await driver.tap(buscarBotonFinder);

       final listFinder = find.byValueKey('listaViajes');
      final viajeBuscadoFinder = find.byValueKey("viaje_0_Buscado");
      final timeline = await driver.traceAction(() async {
        await driver.scrollUntilVisible(
          listFinder,
          viajeBuscadoFinder,
          dyScroll: -300.0,
        );

        expect(await driver.getText(viajeBuscadoFinder), 'viaje_0_Buscado');
      });


      final summary = new TimelineSummary.summarize(timeline);

      summary.writeSummaryToFile('scrolling_summary', pretty: true);

      summary.writeTimelineToFile('scrolling_timeline', pretty: true);
      
    });

  });
}