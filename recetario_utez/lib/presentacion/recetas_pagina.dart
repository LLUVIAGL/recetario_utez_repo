import 'dart:async';

import 'package:flutter/material.dart';

import 'recetas_view_model.dart';
import 'tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  final _controlador = TextEditingController();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _buscar() {
    unawaited(widget.vm.buscar(_controlador.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetario UTEZ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('busqueda'),
                    controller: _controlador,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _buscar(),
                    decoration: const InputDecoration(
                      labelText: 'Receta',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ListenableBuilder(
                  listenable: widget.vm,
                  builder: (context, _) => FilledButton(
                    key: const Key('buscar'),
                    onPressed: widget.vm.cargando ? null : _buscar,
                    child: const Text('Buscar recetas'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.vm,
                builder: (context, _) => _contenido(widget.vm.estado),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contenido(EstadoRecetas estado) => switch (estado) {
    RecetasInicial() => const _Mensaje(
      'Escribe una receta o déjalo vacío y toca Buscar recetas.',
    ),
    RecetasCargando() => const Center(child: CircularProgressIndicator()),
    RecetasVacias(:final busqueda) => _Mensaje(
      busqueda.isEmpty
          ? 'No hay recetas disponibles.'
          : 'No encontramos recetas para "$busqueda".',
    ),
    RecetasFallidas(:final mensaje) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mensaje, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => unawaited(widget.vm.reintentar()),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    ),
    RecetasListas(:final recetas, :final total) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mostrando ${recetas.length} de $total recetas · '
              'Rápidas: ${widget.vm.rapidas}',
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [for (final r in recetas) TarjetaReceta(receta: r)],
          ),
        ),
      ],
    ),
  };
}

class _Mensaje extends StatelessWidget {
  const _Mensaje(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(texto, textAlign: TextAlign.center));
  }
}
