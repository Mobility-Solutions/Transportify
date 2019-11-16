# Guía rápida para el uso de GIT en Transportify

Guía rápida para el uso de Git en nuestro proyecto.

## Estructura

La estructura de ramas para el control de versiones Git de nuestro proyecto es la siguiente:

```bash
├── master_old
├── master
│   ├── sprint1/master
│   │   ├── sprint1/<ID_UT>
│   │   ├── sprint1/<ID_UT>
│   │   ├── sprint1/<ID_UT>
│   ├── sprint2/master
│   │   ├── sprint2/<ID_UT>
│   │   ├── sprint2/<ID_UT>
│   │   ├── sprint2/<ID_UT>
│   ├── sprint3/master
│   │   ├── sprint3/<ID_UT>
│   │   ├── sprint3/<ID_UT>
│   │   ├── sprint3/<ID_UT>
```


## Ramas

A continuación explicamos cada uno de los tipos de rama:

- master_old: es nuestra antigua rama principal que tenemos como backup por si hay un error interno en la estructura.
- master: es la rama principal que contiene todas las ramas de los tres sprints que componen el proyecto.
- sprintX/master: ramas que cuelgan de master, son las que van a contener las ramas que vamos creando por cada UT que contiene el sprint.
- sprintX/ID_UT: ramas que componen sprintX/master y se crean por cada UT del sprint.

## Creación de ramas por tarea

Cuando queramos empezar por una UT específica que tengamos asignada en nuestro tablón, deberemos ejecutar los siguientes comandos:

1.- Situarnos en la rama sprintX/master donde queramos crear nuestra "rama tarea". (*Si estamos trabajando con algún IDE que soporte Control de Versiones lo podremos hacer directamente Ej: En Visual Studio Code en el menú de la izquierda-abajo.*)

```shell
git checkout -b sprintX/master
```

2.- Como ya estamos en la rama donde queramos crear nuestra "rama tarea" procedemos a su creación, mediante el mismo comando *checkout*:

```shell
git checkout -b sprintX/<ID_UT>
# Donde ID_UT es el ID de la UT registrada en nuestro tablón de UTs.
```

3.- A continuación subimos nuestra rama al repositorio remoto con el contenido de la rama sprintX/master sobre la que cuelga:

```shell
git push -u origin sprintX/<ID_UT>
```

## Commits y pusheos de ramas

Este procedimiento, como los anteriores, se puede realizar con el IDE con el que estamos trabajando, también se puede realizar mediante línea de comandos:

IMPORTANTE: los cambios se realizan sobre nuestra "Rama tarea"

1.- Cuando tengamos los cambios de nuestra "rama tarea" nos situamos sobre Transportify/ y añadimos los cambios en nuestro repositorio local:

```shell
git add -A
# Añadimos todos los cambios realizados
```

2.- Realizamos un *commit* con todos los cambios:

```shell
git commit -m "<Mensaje de los cambios realizados.>"
# Añadimos todos los cambios realizados
```

3.- Realizamos un *push* para subir los cambios de los commit:

```shell
git push -u origin sprint1/<ID_UT>
```

## Pull Request y Merge

Cuando ya hayamos acabado la tarea y queramos unir nuestra Rama tarea a la del sprint debemos realizar este proceso mediante GitHub:

1.- Sobre la rama del proyecto en GitHub clicar en "*New pull request*".

2.- Documentar y rellenar la Pull Request.

3.- Asignar como Reviewer de la Pull Request al que vaya a realizar las Pruebas de Aceptación (*si ya se ha asignado esa persona en Worki*) y presionar "*Create pull request*". 

(Si nadie se ha asignado a Pruebas de Aceptación, es la persona que se asigne en Worki la que debe ir a GitHub y asignarse como Reviewer de la Pull Request correspondiente).

4.- El reviewer debe revisar la pull request aplicando las pruebas de aceptación, denegarlo si no se han superado las pruebas o aceptarlo en caso de que se hayan superado y mergear.


## Obteniendo cambios de otras ramas (dependencias)

Cuando necesitemos obtener cambios realizados por otra rama (por ejemplo, porque nuestra UT depende del trabajo de otra), existen varias formas de hacerlo. Puede resultar una operación delicada, porque trabajas con la rama de otro compañero además de la tuya, así que es importante elegir bien.

> Si tienes dudas sobre cuál es la mejor opción, no dudes en comentarlo al resto del equipo. Puede que otros tengan más experiencia con estas situaciones y te sepan guiar mejor.

Las siguientes opciones están ordenadas por el peligro que conllevan, de menos a más.

### Opción 1: Pull Request (hacia *sprintX/master*)

Esta opción sólo es realmente útil si deseas obtener los cambios del *sprintX/master* (cuyo *sprintX* es el mismo de tu UT). 

Consiste en crear una pull request del mismo modo que lo harías si acabas de pasar tu UT a pruebas y planteas mergear con *sprintX/master*.

Sin embargo, como probablemente no esté terminada, indicarás el motivo de su creación (*"mi UT depende de..."*) con un comentario.

Por desgracia, este proceso **sólo te servirá si existen conflictos entre las ramas**. Si esto ocurre, GitHub te lo indicará, y podrás resolverlos ahí mismo. Cuando estén resueltos, se creará automáticamente un *commit* en tu rama con los conflictos resueltos - y con los cambios de la otra rama.

En caso de que no existan conflictos, deberás plantearte otra opción.

En cualquier caso, recuerda cerrar la *Pull request* cuando hayas terminado (haya funcionado o no) para indicar a tus compañeros que la UT aún no está terminada, y no deberían mergearla.

Eso sí, recuerda que cuando la termines, lo mejor es reabrir esta misma *pull request* para aprovecharla, porque si no esta opción pierde toda su gracia, ya que quedaría una *pull request* innecesaria molestando (recuerda que las *pull requests* no se pueden borrar).

#### Por qué es útil

Por un lado, porque avisas a tus compañeros con la simple creación de la *pull request* prematura, además de que lo habrás indicado como comentario.

Y por otro, porque puedes aprovechar *la misma* pull request para cuando tu UT vaya a pasar a pruebas.

### Opción 2: Merge

Es muy habitual que la opción 1 no sea la mejor para ti, especialmente si necesitas cambios de otra UT sin terminar. También puede ocurrir si necesitas cambios de *sprintX/master* pero no hay conflictos.

En ese caso, lo mejor que puedes hacer es un *merge*. 

#### Resolviendo conflictos

**Cuidado**: si haces el *merge* directamente, puede ocurrir que acabes añadiendo cambios de tu rama sin terminar a la otra rama, cuando solo querías obtener lo suyo. Esto ocurre cuando hay *conflictos* entre las ramas. (Esto lo aprovechábamos en la opción 1. Sin embargo, aquí es una faena). Por ello, veamos qué debes hacer en cada situación:

- **Tengo conflictos**

    Vaya, esto conlleva peligro. En este caso, lo mejor es crear una rama provisional a partir de la rama de la que necesites los cambios.

    > Háblalo con el dueño de la otra rama primero, o con todos si se trata de *sprintX/master*.

    Llámala `sprintX/<UT-cambios-o-master>-<tu-UT>`. (fíjate en el guión entre ambas UT, esto indicará al resto que estás pasando cambios de una UT (o del master) a la tuya).

    Tras esto, realizas el merge de la nueva rama provisional a la tuya. Así, los cambios sin terminar que surgen de tu rama, acaban en la provisional, en lugar de la del compañero.

    A partir de aquí, el curso de acción difiere según la rama de la que has obtenido cambios.

    - **sprintX/master**

        Si los cambios vienen de un master, no hay problema. Continúa con tu rama como si nada, y olvídate de la provisional (podrías incluso borrarla si quieres, para que no moleste).

    - **Otra UT (también sin terminar)**

        Si viene de otra UT sin terminar, es que las dependencias son grandes. Ahora bien: ¿Quién depende de quién?

        - **Mi rama depende de la suya**

            Si dependes de su rama, pero la otra persona de la tuya no, entonces deberás seguir haciendo *merges* conforme vayas necesitando cambios (borrando y volviendo a crear la rama provisional por cada uno), y no podrás terminar tu UT hasta que la suya no esté terminada (en cuyo caso mergeas del *sprintX/master*).

        - **Ambas dependen de la otra**

            En ese caso, ninguna rama podrá terminar sin la otra. Deberéis trabajar desde vuestra rama, pero usando la rama conjunta para ir obteniendo los cambios del otro. Cuando cada uno termine su rama, hará la *pull request* **hacia la rama conjunta**, en lugar de hacerlo hacia *sprintX/master*.
            
            Cuando ambas UTs hayan terminado, uno de los dos deberá crear una *pull request* **desde la rama conjunta** hacia *sprintX/master*, puesto que ya no hay dependencias entre las dos ramas.

- **No tengo conflictos**

    Genial, en principio no debería haber problema. Haces un merge de su rama a la tuya y listo. Aun así, yo lo comentaría al dueño de la otra rama primero por si acaso (nunca se sabe).

- **No estoy seguro**

    Si no estás seguro, lo mejor es curarse en salud y *seguir los pasos del caso en el que tienes conflictos*. Así, si los hay, *no le fastidias la rama al compañero*. (También puedes preguntar a otros compañeros primero, por si acaso).

#### Cómo hacer el *merge*

En cuanto a cómo hacer el *merge*, depende de lo importante que sea dejar constancia de todo, y que tus compañeros estén al tanto de ello.

- **Pull Request (hacia tu rama)**

    Si crees que lo mejor es que quede constancia, una *pull request* de la otra rama hacia la tuya debería resolver este problema. Todo el mundo lo verá, y puedes dejar comentarios explicando tus motivos, además de generar discusión (en el buen sentido), sobre las dependencias entre estas ramas, a qué se deben, y cómo se deben tener en cuenta de cara al *sprint*.

    Eso sí, si vas a hacer varios *merges* entre las mismas ramas, yo sólo haría 1 *pull request* la primera vez, porque recuerda que todas se quedan ahí, y hacer muchas resultaría molesto para todos. Si ya has hecho una y tienes que hacer más, las haría de forma manual (salvo que sea muy significativo ese *merge* en concreto y creas que es necesario que quede constancia por algún motivo).

- **Merge manual**

    El merge manual es un clásico. Aquí los pasos:
    
    1.- Situarnos en la otra rama (de la que queremos obtener los cambios):

    ```shell
    git checkout -b sprintX/<La-otra-UT-o-master>
    ```

    2.- Realizamos un *pull* para obtener los cambios de la rama:

    ```shell
    git pull
    ```

    3.- Volvemos a la rama que necesita los cambios (o sea, tu rama):

    ```shell
    git checkout -b sprintX/<TU_UT>
    ```

    4.- Realizamos *merge* de la otra rama (de la que queremos obtener los cambios) y solucionamos los conflictos que surjan entre ambas ramas (si hay) (*Muy recomendado hacerlo desde la IDE*):

    ```shell
    git merge sprintX/<La-otra-UT-o-master>
    ```

    5.- Actualizamos los cambios en remoto:

    ```shell
    git push
    ```
    Con esto ya hemos obtenido los cambios de otra rama en la nuestra.

### Opción 4: Rebase

**MUCHO CUIDADO**: Esta opción es **muy peligrosa, y la puedes liar parda**. Si te crees obligado a utilizarla, **coméntalo antes con el resto de compañeros del equipo**. Es posible que no sea necesaria, y una de las otras opciones haga el mismo trabajo. Si se llega a la conclusión de que es necesario, adelante. *Es especialmente peligrosa en ramas donde han trabajado varias personas. Avisa a aquellos que hayan trabajado en la rama afectada*.

Esta opción consiste en realizar un *rebase* de dicha rama *hacia la nuestra*. Esto se puede realizar desde nuestra IDE o mediante línea de comandos. Pasos a seguir:

1.- Situarnos en la otra rama (de la que queremos obtener los cambios):

```shell
git checkout -b sprintX/<La-otra-UT-o-master>
```

2.- Realizamos un *pull* para obtener los cambios de la rama:

```shell
git pull
```

3.- Volvemos a la rama que necesita los cambios (o sea, tu rama):

```shell
git checkout -b sprintX/<ID_UT>
```

4.- Realizamos *rebase* de la rama y solucionamos los conflictos que surjan entre ambas ramas (si hay) (*Muy recomendado hacerlo desde la IDE*):

```shell
git rebase sprintX/<La-otra-UT-o-master>
```

5.- Actualizamos los cambios en remoto:

```shell
git push --force
```
Con esto ya hemos obtenido los cambios de otra rama en la nuestra.

**IMPORTANTE**: Debido a que el *rebase* resetea los *commits* afectados y los vuelve a realizar, las versiones locales y remotas dejan de coincidir (de ahí el *--force*), y genera problemas en aquellas versiones locales de vuestra rama que tengáis (en todas salvo en aquella desde la que hayáis hecho el *rebase*).

Si tenéis vuestra rama en distintos sitios, debéis realizar los siguientes pasos en los repositorios locales afectados:

>**Aviso**: Aseguraos de que todo vuestro trabajo local esté actualizado en remoto. Tras seguir estos pasos, todo el trabajo local que no se haya subido se perderá (incluso los commits locales).

1.- Situarnos en la rama afectada (donde obtuvisteis los cambios):

```shell
git checkout -b sprintX/<ID_UT>
```
2.- Descargamos la última versión remota de todas las ramas:

```shell
git fetch --all
```
*(esto no generará conflictos, pues no hará comparaciones con las locales)*

3.- Reseteamos la rama local para que coincida con la remota:
```shell
git reset --hard origin/sprintX/<ID_UT>
```

En principio con esto debería estar todo arreglado. En el caso de que tengáis más problemas, borrar el repositorio local y volver a clonarlo seguramente solucione el problema.

>Recordad: si tenéis problemas con vuestro repositorio local, **nunca** hagáis push con el repositorio remoto, porque vuestros problemas acabarán ahí. Siempre es mejor borrar el repositorio y volverlo a clonar, que tener que arreglar errores que hayan acabado en la versión remota. *(Siempre y cuando no tengáis trabajo local sin pushear, en ese caso mejor no perderlo, claro)*

## Bibliografía

- https://yangsu.github.io/pull-request-tutorial/
- https://gist.github.com/aaossa/7db152babead60ab097ba2c898d379a6
- https://stackoverflow.com/questions/4470523/create-a-branch-in-git-from-another-branch/27318410
- https://www.atlassian.com/git/tutorials/cherry-pick
- https://git-scm.com/docs/git-rebase
- https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files
