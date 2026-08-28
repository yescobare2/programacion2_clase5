# Clase 5 - CRUD con JDBC, con Maven

Ejemplo de un **CRUD completo** (Crear, Leer, Actualizar, Eliminar) contra MySQL desde
Java, usando **Maven** para manejar la dependencia del driver JDBC. Compara este
proyecto con `clase05-jdbc-sin-maven` para ver exactamente que automatiza Maven.

## Estructura del proyecto

```
src/main/java/edu/umg/programacion2/clase05/
├── Main.java              -> menu de consola (entrada/salida con el usuario)
├── modelo/Estudiante.java -> clase de dominio (solo datos + encapsulamiento)
└── dao/EstudianteDAO.java -> TODO el codigo SQL/JDBC vive aqui
```

`Main` nunca escribe SQL directamente: solo llama metodos de `EstudianteDAO` como
`crear(...)`, `listarTodos()`, `buscarPorCarnet(...)`, `actualizarNombre(...)` y
`eliminar(...)`. Esta separacion (interfaz de usuario vs. acceso a datos) es una
version simple del **DAO pattern** que van a formalizar mas adelante en el curso.

## Que es un driver JDBC (y por que lo necesitamos)

Java no sabe hablar el protocolo de MySQL de fabrica. JDBC (Java Database
Connectivity) es la API estandar que Java define para conectarse a bases de datos, pero
cada motor (MySQL, PostgreSQL, SQL Server, etc.) necesita su propia implementacion de
esa API: el **driver**. En el proyecto sin Maven ese .jar se descarga y se referencia a
mano. Aca, en cambio, lo declaramos como una dependencia en `pom.xml` y Maven lo baja
solo desde Maven Central la primera vez que compilas.

## Requisitos

- JDK 11 instalado (`java -version`).
- Maven instalado (`mvn -v`).
- MySQL 8 corriendo en `localhost:3306` (el que instalaste para la tarea de la Clase 3).

## Paso 1: crear la base de datos

Ejecuta `sql/schema.sql` en MySQL Workbench o desde la consola:

```bash
mysql -u root -p < sql/schema.sql
```

## Paso 2: configurar la conexion

Abre `src/main/java/edu/umg/programacion2/clase05/Main.java` y ajusta `USUARIO` y
`PASSWORD` con tus credenciales reales de MySQL.

## Paso 3: compilar

```bash
mvn compile
```

La primera vez que corras esto, Maven va a descargar `mysql-connector-j-8.0.33.jar` a
tu repositorio local (`~/.m2/repository`). Las siguientes veces ya lo tiene en cache y
no vuelve a descargarlo.

## Paso 4: ejecutar

```bash
mvn exec:java
```

## Alternativa: importar en Eclipse

Este workspace es de Eclipse (`eclipse-workspace-umg`). Podes hacer
`File > Import... > Maven > Existing Maven Projects`, seleccionar esta carpeta, y
correr `Main.java` directo con `Run As > Java Application` — Eclipse arma el classpath
con la dependencia de Maven automaticamente.

## Salida esperada

```
=== CRUD de Estudiantes (MySQL) ===
1. Agregar estudiante
2. Listar todos los estudiantes
3. Buscar estudiante por carnet
4. Actualizar nombre de un estudiante
5. Eliminar estudiante
6. Salir
Elige una opcion: 2
[1] Ana Lopez - carnet 2024001
[2] Carlos Perez - carnet 2024002
[3] Maria Gonzalez - carnet 2024003
```

## Nota sobre `Class.forName(...)`

En tutoriales viejos vas a ver una linea como
`Class.forName("com.mysql.cj.jdbc.Driver")` antes de conectar. Desde JDBC 4.0 (Java 6
en adelante) ya no hace falta: el driver se registra solo con `DriverManager` gracias a
un mecanismo llamado *Service Provider Interface*. Si ves ese codigo en internet, ahora
sabes por que ya no es necesario escribirlo.

## Errores comunes

```
# Error: no suitable driver found for jdbc:mysql://...
```
Si esto pasa con Maven, normalmente significa que la dependencia no quedo bien
declarada en `pom.xml`, o que corriste la clase con un classpath armado a mano (por
ejemplo, `java -cp target/classes ...`) sin incluir la dependencia. Usa `mvn exec:java`.

```
# Error: Access denied for user 'root'@'localhost'
```
El usuario o password en `Main.java` no coinciden con los de tu instalacion de MySQL.

## Que gano usando Maven vs. hacerlo a mano

| | Sin Maven | Con Maven |
|---|---|---|
| Conseguir el driver | Descargar el .jar manualmente | `mvn compile` lo descarga solo |
| Actualizar de version | Bajar otro .jar y reemplazar | Cambiar un numero en `pom.xml` |
| Compartir el proyecto | Hay que compartir el .jar tambien (o instrucciones) | `pom.xml` alcanza; cualquiera con Maven reconstruye igual |
| Compilar | `javac -cp ...` a mano | `mvn compile` |

## Ejercicio propuesto

Agrega una validacion en `agregarEstudiante()`: si el nombre o el carnet vienen
vacios, muestra un mensaje de error y no llames a `estudianteDAO.crear(...)`
(pista: `String.isBlank()`).
