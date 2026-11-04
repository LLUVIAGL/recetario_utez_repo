import '../dominio/receta.dart';

Dificultad dificultadDesdeTexto(Object? valor) => switch (valor) {
  'Easy' => Dificultad.facil,
  'Medium' => Dificultad.media,
  'Hard' => Dificultad.dificil,
  _ => Dificultad.desconocida,
};


Receta recetaDesdeJson(Map<String, dynamic> json) {
  switch (json) {
    case {
    'id': int id,
    'name': String nombre,
    'cuisine': String cocina,
    'prepTimeMinutes': int preparacion,
    'cookTimeMinutes': int coccion,
    'servings': int porciones,
    'rating': num calificacion,
    }:
      return Receta(
        id: id,
        nombre: nombre,
        cocina: cocina,
        dificultad: dificultadDesdeTexto(json['difficulty']),
        minutosPreparacion: preparacion,
        minutosCoccion: coccion,
        porciones: porciones,
        calificacion: calificacion.toDouble(),
        etiquetas: _listaDeTextos(json['tags'], 'tags'),
        ingredientes: _listaDeTextos(json['ingredients'], 'ingredients'),
      );
    default:
      throw const FormatException(
        'Receta con campos obligatorios faltantes o de tipo incorrecto',
      );
  }
}


PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  switch (json) {
    case {'recipes': List<dynamic> lista, 'total': int total}:
      final recetas = <Receta>[];
      for (final elemento in lista) {
        if (elemento is! Map<String, dynamic>) {
          throw const FormatException('Un elemento de "recipes" no es un objeto');
        }
        recetas.add(recetaDesdeJson(elemento));
      }
      return PaginaRecetas(recetas: recetas, total: total);
    default:
      throw const FormatException('Faltan "recipes" o "total" en la respuesta');
  }
}


List<String> _listaDeTextos(Object? valor, String campo) {
  if (valor == null) return const [];
  if (valor is! List) {
    throw FormatException('"$campo" debe ser una lista');
  }
  final textos = <String>[];
  for (final elemento in valor) {
    if (elemento is! String) {
      throw FormatException('"$campo" solo puede tener textos');
    }
    textos.add(elemento);
  }
  return textos;
}
