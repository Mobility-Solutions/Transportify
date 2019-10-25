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
3. Para seguir teniendo el constructor además del método, ahora el constructor llama al constructor padre así:

    ```dart
    PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot);
    ```

    Y el padre ya se encarga de llamar al método `loadFromSnapshot`.

## Fin
Y con esto ya debería estar todo. Si tienes cualquier otra duda, consulta la guía. Y si esta no te la resuelve, no dudes en preguntar.
