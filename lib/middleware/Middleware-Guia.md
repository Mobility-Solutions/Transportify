# Guía de uso del Middleware

## Obtener los datos de una colección o un documento

Para obtener los datos de una colección o de un documento, debes hacer uso de los métodos `Datos.obtenerStreamBuilderCollectionBD(...)` y `Datos.obtenerStreamBuilderDocumentBD(...)` respectivamente.

Ambos métodos aceptan dos argumentos:
- Un `String` con el *path* a la colección o al documento del que deseas obtener sus datos.
- Una función *builder* (clase `Function`) que devuelva un `Widget` (aquel que requiere acceder a la colección o al documento), y que acepte dos argumentos:
    - Un `BuildContext` (en la mayoría de casos no le darás uso)
    - Un `AsyncSnapshot<QuerySnapshot>` para una colección, o `AsyncSnapshot<DocumentSnapshot>` en el caso de un documento. De aquí obtendrás la colección o el documento.

La idea es que el `Widget` que cree la función *builder* tendrá acceso a la colección o documento que necesita, y se actualizará automáticamente en cuanto la colección o documento sufran cualquier cambio.

Ejemplo de una función *builder* para el caso de una *colección*:

```dart
static Widget _obtenerWidget(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Mientras la colección o documento aún no estén disponibles, muestras algo que indique al usuario que se está cargando el Widget
    if (!snapshot.hasData) return const Text('Cargando...');

    // Esta ruta contiene la colección
    List<DocumentSnapshot> coleccion = snapshot.data.documents;

    return (...) // Devuelves el Widget, ya sea desde otro método tuyo que tengas, o directamente lo construyes aquí 
  }
```

Ejemplo para el caso de un *documento*:

```dart
static Widget _obtenerWidget(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    // Mientras la colección o documento aún no estén disponibles, muestras algo que indique al usuario que se está cargando el Widget
    if (!snapshot.hasData) return const Text('Cargando...');

    // Esta ruta contiene el documento
    DocumentSnapshot documento = snapshot.data;

    return (...) // Devuelves el Widget, ya sea desde otro método tuyo que tengas, o directamente lo construyes aquí 
  }
```

Una vez tienes la función *builder* y el *path* de la colección o documento que necesitas, solo tienes que crear un método público que llame al Middleware de esta forma:

*Colección*
```dart
static const String coleccion_puntos = ... // Path de la colección

static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado() {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_puntos, _obtenerWidget);
  }
```

*Documento*
```dart
static const String documento_punto = ... // Path del documento

static StreamBuilder<DocumentSnapshot> obtenerStreamBuilderPunto() {
    return Datos.obtenerStreamBuilderDocumentBD(documento_punto, _obtenerWidget);
  }
```

### Necesito argumentos extra que recibo de quien llama a mi método. ¿Qué hago?
Si necesitas cualquier dato para el Widget que creas que depende de quien llama a tu método (por ejemplo, un handler cuando el usuario hace clic en algo, o un valor para tu Widget que depende de la ventana), una forma de hacerlo es a través de una *clausura*. Esto lo que permite es que el *builder* mantenga guardado el valor que le pasaste al crearlo, y lo utilice cada vez que se actualice.

Un ejemplo para `PuntoTransportify`:

```dart
  static const String coleccion_puntos = ... // Path de la colección

  // Función que, pasándole un builder, lo mapea con la colección que le he dado.
  // No es necesaria como tal, pero puede venir bien
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderListado(
      Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return Datos.obtenerStreamBuilderCollectionBD(coleccion_puntos, builder);
  }

  // Esta es la función a la que llamarían de fuera para obtener tu Widget.
  // Pasan como argumentos los datos que necesitamos para nuestro Widget.
  static Widget obtenerDropDownCiudadesYListadoPuntos(
      {Function(String) onCiudadChanged,
      String ciudadValue,
      Function(PuntoTransportify) onPuntoChanged}) {
    return obtenerStreamBuilderListado(
        _obtenerDropDownBuilder(onCiudadChanged, ciudadValue, onPuntoChanged));
  }

  // Aquí es donde ocurre la magia (la clausura). A este método le pasamos los datos que el Widget necesita, y devuelve una función lambda builder, que llama a nuestra función builder de verdad, pasándole nuestros datos.

  // Esto crea una clausura, lo cual quiere decir que la función lambda se "guarda" los valores de nuestros datos, ya que en cuanto es devuelta, pierde el acceso (el scope) a las variables originales.

  // Así es como conseguimos mantener un valor que pasó de forma dinámica quien quiso crear el StreamBuilder, y lo utilizamos como si fuera un valor estático.

  static Function(BuildContext, AsyncSnapshot<QuerySnapshot>) _obtenerDropDownBuilder(Function(String) onCiudadChanged, String ciudadValue, Function(PuntoTransportify) onPuntoChanged) {
    return (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return _obtenerDropDownCiudadesYListadoPuntos(
          context, snapshot, onCiudadChanged, ciudadValue, onPuntoChanged);
    };
  }


  // Este es el método builder "de verdad". El que realmente crea el Widget que se mostrará en pantalla. Los argumentos que hemos clausurado siempre tendrán los mismos valores entre llamadas al builder del StreamBuilder devuelto, así que podrán ser usados con total normalidad.
  static Widget _obtenerDropDownCiudadesYListadoPuntos(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Function(String) onCiudadChanged,
      String ciudadSeleccionada,
      Function(PuntoTransportify) onPuntoChanged) {...}
```

### Cómo obtener los atributos y sus valores a partir de un documento
Cuando tienes un documento (clase `DocumentSnapshot`), este funciona cono un `Map<string, dynamic>`. Puedes obtener los datos usando indización como cualquier otro `Map`.

Ejemplo:
```dart
// Obtenemos un documento de donde sea
DocumentSnapshot documento = ... ;

// Imagina que queremos acceder al campo 'nombre' del documento, cuyo valor es de tipo String
String nombre = documento['nombre'];

// Y así con cualquier campo
```
#### Facilitando el acceso a los campos de un documento
Para poder acceder fácilmente a los campos de un documento, lo ideal es tener todos los nombres de los campos guardados como constantes de tipo `String`, ya que seguramente los tengas que utilizar en múltiples ocasiones.

Por ejemplo, para la clase `PuntoTransportify`, están definidos así (en la clase del middleware `PuntoTransportifyDB`):
```dart
  static const String atributo_nombre = 'nombre';
  static const String atributo_direccion = 'direccion';
  static const String atributo_ciudad = 'ciudad';
  static const String atributo_localizacion = 'localizacion';
```

Además, es recomendable disponer de métodos que accedan al campo del documento directamente por ti, para que las llamadas desde otras clases sean más claras y concisas.

```dart
  static String obtenerNombre(DocumentSnapshot documento) => documento[atributo_nombre];
  static String obtenerDireccion(DocumentSnapshot documento) => documento[atributo_direccion];
  static String obtenerCiudad(DocumentSnapshot documento) => documento[atributo_ciudad];
  static GeoPoint obtenerLocalizacion(DocumentSnapshot documento) => documento[atributo_localizacion];
```
Para crear la instancia de tu objeto a partir del `DocumentSnapshot`, lo ideal sería crear un constructor apropiado. Este es el constructor de `PuntoTransportify`:
```dart
PuntoTransportify.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID; // La id no requiere acceso al Map, está en este atributo
    this.nombre = PuntoTransportifyBD.obtenerNombre(snapshot);
    this.direccion = PuntoTransportifyBD.obtenerDireccion(snapshot);
    this.ciudad = PuntoTransportifyBD.obtenerCiudad(snapshot);

    GeoPoint localizacion = PuntoTransportifyBD.obtenerLocalizacion(snapshot);
    this.latitud = localizacion?.latitude;
    this.longitud = localizacion?.longitude;
  }
```
Como puedes ver, aprovechamos los métodos creados anteriormente para obtener cada uno de los atributos necesarios para el objeto.

## Crear y modificar documentos

Tanto para crear documentos como para modificar existentes, necesitas un método que te convierta el objeto asociado en un `Map<string, dynamic>`.

- La `key` es una `String` indicando el nombre del campo para la Base de datos.
- El `value` es el valor de ese campo. (`dynamic` quiere decir que puede ser de cualquier tipo)

Ejemplo para la clase `PuntoTransportify`:

```dart
  static Map<String, dynamic> puntoToMap(PuntoTransportify punto) {
    Map<String, dynamic> map = Map<String, dynamic>();
    
    map[atributo_nombre] = punto.nombre;
    map[atributo_direccion] = punto.direccion;
    map[atributo_ciudad] = punto.ciudad;

    GeoPoint localizacion = GeoPoint(punto.latitud, punto.longitud);
    map[atributo_localizacion] = localizacion;

    return map;
  }
```
>Este código no forma parte del código de la aplicación actualmente, porque la clase `PuntoTransportify` no permite ninguna alteración del listado de puntos desde dentro de la app.

A partir de este punto, los pasos para crear y para modificar documentos son distintos.

### Crear documentos

Una vez tengas el método de conversión a Map, creas un método público, con el cual podrás crear documentos de tu objeto en la Base de Datos a partir de una instancia del mismo.

Este sólo deberá llamar al método conversor que creaste en el *primer paso* para obtener el `Map`. Este servirá al método `Datos.crearDocument(...)` para crear el documento a partir de los campos y sus valores.

```dart
static Future<DocumentReference> crearPuntoEnBD(PuntoTransportify punto) {
    Map<String, dynamic> entryMap = puntoToMap(punto);
    return Datos.crearDocument(coleccion_puntos, entryMap);
  }
```
>El parámetro `coleccion_puntos` es una `String` *constante* con el path de la colección en la base de datos. En el caso de `PuntoTransportify`, su valor es `'puntos_transportify'`.

### Modificar documentos
 
 Para modificar un documento ya existente, necesitas una referencia (`DocumentReference`) del documento que deseas modificar. Para ello, lo más sencillo es guardarla cuando obtienes el documento (véase la *primera sección* para más detalles). Para obtenerlo a partir del `DocumentSnapshot`, sólo tienes que llamar al atributo `reference` de este. Guárdalo como atributo en tu objeto cuando lo construyas a partir de la `snapshot` (Mira el apartado *"Facilitando el acceso a los campos de un documento"* para más detalles). Ya con la referencia, solo debes llamar al método `setData(...)` pasándole el `Map` que puedes crear gracias al método que has hecho anteriormente.

 ## Borrar documentos

 Para borrar documentos, necesitas la `DocumentReference` del documento que deseas borrar, al igual que ocurre al querer *modificarlo* (mira la sección *"Modificar documentos"* para saber cómo conseguirla). Aquí, es tan fácil como llamar al método `delete()` de esta clase.