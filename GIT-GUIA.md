# Guía rápida para el uso de GIT en Transportify

Guía rápida para el uso de Git en nuestro proyecto.

## Estructura

La estructura de ramas para el control de versiones Git de nuestro proyecto es la siguiente:

+-- master_old

+-- master

&nbsp; |   +-- sprint1/master

&nbsp; &nbsp; &nbsp;||   +-- sprint1/<ID_UT>

&nbsp; &nbsp; &nbsp;||   +-- sprint1/<ID_UT>

&nbsp; &nbsp; &nbsp;||   +-- sprint1/<ID_UT>

&nbsp; &nbsp; &nbsp;||   +-- ...

&nbsp; |   +-- sprint2/master

&nbsp; &nbsp; ||   +-- sprint2/<ID_UT>

&nbsp; &nbsp; ||   +-- ...

&nbsp; |   +-- sprint3/master

&nbsp; &nbsp; ||   +-- sprint3/<ID_UT>

&nbsp; &nbsp; ||   +-- ...


## Ramas

A continuación explicamos cada uno de los tipos de rama:

- master_old: es nuestra antigua rama principal que tenemos como backup por si hay un error interno en la estructura.
- master: es la rama principal que contiene todas las ramas de los tres sprints que componen el proyecto.
- sprintX/master: ramas que cuelgan de master, son las que van a contener las ramas que vamos creando por cada UT que contiene el sprint.
- sprintX/ID_UT: ramas que componen sprintX/master y se crean por cada UT del sprint.

## Creación de ramas por tarea

Cuando queramos empezar por una UT específica que tengamos asignada en nuestro tablón, deberemos ejecutar los siguientes comandos:

1.- Situarnos en la rama sprintX/master donde queramos crear nuestra "rama tarea". (*Si estamos trabajando con algún IDE que soporte Control de Versiones lo podremos hacer directamente Ej: En Visual Studio Code en el menú de la derecha abajo.*)

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
En caso de que necesitemos obtener cambios realizados por otra rama (por ejemplo, porque nuestra UT depende del trabajo de otra), debemos de realizar un *merge* de dicha rama *hacia la nuestra*. Esto se puede realizar desde nuestra IDE o mediante línea de comandos:

1.- Situarnos en nuestra "rama tarea".

```shell
git checkout -b sprintX/<ID_UT>
```

2.- Realizamos un *merge* con la rama de la cual queremos obtener cambios:

```shell
git merge <rama de la que dependes>
```

3.- Solucionamos los conflictos que surjan entre ambas ramas (si hay) (*Muy recomendado hacerlo desde la IDE*)


4.- Realizamos un *commit* con todos los cambios:

```shell
git commit -m "<Mensaje avisando del merge que has hecho, y para qué era.>"
```

5.- Realizamos un *push* para subir los cambios del merge:

```shell
git push -u origin sprint1/<ID_UT>
```

## Bibliografía

- https://yangsu.github.io/pull-request-tutorial/
- https://gist.github.com/aaossa/7db152babead60ab097ba2c898d379a6
- https://stackoverflow.com/questions/4470523/create-a-branch-in-git-from-another-branch/27318410
- https://www.atlassian.com/git/tutorials/cherry-pick
