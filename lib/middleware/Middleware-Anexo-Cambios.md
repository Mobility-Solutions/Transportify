# Adaptarse a los cambios en el Middleware

El middleware ha sufrido algunos cambios desde el Sprint 1. Para poder adaptarse al nuevo sistema, estas son las cosas que debes cambiar:

## Heredar de `ComponenteBD`

Si tu clase está asociada a un documento en la base de datos, esta debe heredar en `ComponenteBD`. Esto implica lo siguiente:

### Creando un nuevo documento en la Base de Datos

Antes, para crear un documento en la base de datos, necesitabas tener tu propio método, como este:

```dart
static Future<DocumentReference> crearPuntoEnBD(PuntoTransportify punto) {
    Map<String, dynamic> entryMap = puntoToMap(punto);
    return Datos.crearDocument(coleccion_puntos, entryMap);
}
```

Ahora, `ComponenteBD` se encarga de casi todo. Solo necesita de dos cosas:
- Un método `toMap()` que te dé un `Map` en base a los campos del objeto. En el código anterior sería equivalente al método `puntoToMap(punto)`. Con lo cual, solo debes mover este método a la clase de tu objeto y renombrarlo.
- Una referencia a la colección asociada a tu objeto. Esto en el código anterior sería la String `coleccion_puntos`, la cual ahora pasarías al constructor de `ComponenteBD` (más detalles en el apartado "*Creando una nueva instancia de un `ComponenteBD`*" de la guía).

### Construyendo tu objeto a partir de una `DocumentSnapshot`

Anteriormente, teníamos simplemente un constructor como este:

```dart
PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;

    this.nombre = PuntoTransportifyBD.obtenerNombre(snapshot);
    this.direccion = PuntoTransportifyBD.obtenerDireccion(snapshot);
    this.ciudad = PuntoTransportifyBD.obtenerCiudad(snapshot);

    GeoPoint localizacion = PuntoTransportifyBD.obtenerLocalizacion(snapshot);
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
}
```

Ahora, hay un par de cambios:

1. Además de el constructor, hay un método `loadFromSnapshot(DocumentSnapshot snapshot)`, proveniente de `ComponenteBD` el cual se debe sobrecargar. Todo lo del constructor `fromSnapshot` debería ser movido a este nuevo método. Esto se necesita para la nueva función de revertir `revertFromBD()`.
2. Como de las id (como de todo lo de la BD) se encarga la clase `ComponenteBD`, en lugar de hacer la llamada siguiente: `this.id = snapshot.documentID;` llamamos al método padre para que se encargue de todo: `super.loadFromSnapshot(snapshot);`

    Del mismo modo, si tu clase tenía algún atributo para la `id`, ya puedes quitarlo. `ComponenteBD` ya tiene el suyo propio, y lo heredas junto a lo demás.

3. Para seguir teniendo el constructor además del método, ahora el constructor llama al constructor padre así:

    ```dart
    PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);
    ```

    Y el padre ya se encarga de llamar al método `loadFromSnapshot`.

## Referenciando otros objetos de la base de datos

Debido a que ahora todos los objetos relacionados con la base de datos heredarán de `ComponenteBD`, ya no es necesario guardar atributos con las id de las instancias a las que quieras referenciar.

En su lugar, guardarás la instancia del objeto, como harías normalmente en la lógica. Así, en vez de "`String destinoId`", tendrás "`PuntoTransportify destino`" (ejemplo de la clase `Paquete`).

### ¿Y cómo guardo su referencia en la base de datos?

Pues del mismo modo que ya no guardas la `id` en la lógica, la base de datos contiene un tipo `reference` que te permite referenciar otros objetos de la base de datos.

Para obtener la `reference` del objeto, solo necesitas llamar a su atributo `reference`. Esto lo haces en el método `toMap()`, y así en vez de tener la instancia del objeto, tienes su `DocumentReference` en el `Map` que obtendrá la base de datos.


>Código adaptado del antiguo método `viajeToMap()` para la clase `Viaje`.

```dart
Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map[atributo_id_destino] = viaje.destino.reference; // Anteriormente: viaje.destinoId;
    map[atributo_id_origen] = viaje.origen.reference;
    map[atributo_id_transportista] = viaje.transportista.reference;
    map[atributo_carga_maxima] = viaje.cargaMaxima;
    map[atributo_fecha] = viaje.fecha;

    return map;
}
```

### Ya lo tengo en la base de datos. Ahora necesito extraer el objeto de su referencia.

Cuando quieras obtener un objeto de la base de datos, y éste contenga referencias a otros objetos, lo mejor que puedes hacer es utilizar el método estático `tratarReferencias(Map)` de la clase `Datos`.

Le pasas el `snapshot` del objeto del que necesites referencias, y éste obtendrá todos los `snapshots` asociados a las referencias de tu objeto.

>El método `tratarReferencias` es asíncrono, con lo cual deberás asegurarte de que si tu método es síncrono, todo lo que se haga después esté en el `.then(...)` de la llamada, para que espere a que termine. Alternativamente, si tu método también es asíncrono, puedes esperarlo con `await`.

Una vez tratadas las referencias, puedes cargarlo normalmente en tu objeto. Sólo debes tener en cuenta una cosa, y es que tendrás que crear instancias de los objetos a los que referencies.

>Código adaptado del antiguo constructor `fromSnapshot()` de la clase `Viaje`.

```dart
void loadFromSnapshot(DocumentSnapshot snapshot) {
    super.loadFromSnapshot(snapshot);

    this.cargaMaxima = snapshot[ViajeBD.atributo_carga_maxima];
    this.fecha = snapshot[ViajeBD.atributo_fecha];

    this.destino = PuntoTransportify.fromSnapshot(snapshot[ViajeBD.atributo_destino]);
    this.origen = PuntoTransportify.fromSnapshot(snapshot[ViajeBD.atributo_origen]);
    this.transportista = Transportista.fromSnapshot(snapshot[ViajeBD.atributo_transportista]);
}
```

>*A tener en cuenta*: Si tienes otras instancias del mismo objeto, estas no se actualizarán simultáneamente en local, pero en cuanto llames a `updateBD` en uno de ellos, sus datos coincidarán con los de la base de datos. Si quieres que otras instancias se actualicen, puedes llamar `revertToBD` en todas ellas para sincronizarse con la base de datos.

## Fin
Y con esto ya debería estar todo. Si tienes cualquier otra duda, consulta la guía. Y si esta no te la resuelve, no dudes en preguntar.
