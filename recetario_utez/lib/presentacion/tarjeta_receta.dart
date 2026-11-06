import 'package:flutter/material.dart';

import '../dominio/receta.dart';

class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(receta.nombre, style: tema.titleMedium),
            const SizedBox(height: 4),
            Text('${receta.cocina} · ${receta.dificultad.etiqueta}'),
            const SizedBox(height: 4),
            Text(
              'Tiempo: ${receta.tiempoTotal} min · '
                  'Porciones: ${receta.porciones}',
            ),
            Text('Calificación: ${receta.calificacion.toStringAsFixed(1)}'),
            if (receta.esRapida)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Chip(label: Text('Rápida')),
              ),
          ],
        ),
      ),
    );
  }
}
