# Evidencias — Recetario UTEZ

**Nombre:** Lluvia Gonzalez Luviano
**Matrícula:** 20233tn142
**Fecha:** 06-noviembre-2026
**Dispositivo donde se probó:**  emulador Android

##  Preguntas de reflexión

1. **¿En qué se diferencian el escenario "Error del servidor" y "Sin red" desde el punto de vista de HTTP?**
   En el error del servidor sí hubo conversación HTTP: la petición llegó, el servidor respondió y trajo un código de estado (503). Dio lo reporta como `badResponse` y por eso se traduce a `ErrorDelServidor(503)`. En "Sin red" la petición nunca llegó al servidor: no hay respuesta, ni código, ni cuerpo; Dio lo reporta como `connectionError` y se traduce a `SinConexion`.

2. **¿Por qué "Vacío" no es un error?**
   Porque la petición salió bien: el servidor respondió 200 con `"recipes": []` y `"total": 0`. Es un resultado válido ("no hay coincidencias"), no una falla. Por eso se representa con su propio estado (`RecetasVacias`) y un mensaje que dice qué se buscó, sin botón de reintentar.

3. **La búsqueda de la persona viaja en la query. ¿Por qué tu bitácora no la escribe?**
   Porque lo que alguien escribe es un dato de la persona y puede ser sensible; las bitácoras se copian, se comparten y se guardan. Por eso la bitácora solo usa método, `options.path`, código, tipo de error y tiempo, y nunca la query ni `options.uri`.

4. **Si DummyJSON cambiara `rating` por `score`, ¿qué archivos tendrías que modificar y por qué solo esos?**
   Solo `lib/datos/recetas_json.dart` (en `recetaDesdeJson`, la llave `'rating'` del patrón pasaría a `'score'`). El resto no cambia porque el dominio ya habla en `calificacion` y no sabe nada de JSON, y el ViewModel y las vistas solo consumen `Receta`: el nombre de la llave está aislado en la capa que convierte JSON a objetos.
