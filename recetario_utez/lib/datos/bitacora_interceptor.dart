import 'dart:developer' as developer;

import 'package:dio/dio.dart';


class BitacoraInterceptor extends Interceptor {
  BitacoraInterceptor({void Function(String linea)? escribir})
      : _escribir = escribir ?? _escribirEnConsola;

  final void Function(String linea) _escribir;

  static const _claveCronometro = 'bitacora_cronometro';

  static void _escribirEnConsola(String linea) {
    developer.log(linea, name: 'recetario');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_claveCronometro] = Stopwatch()..start();
    _escribir('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final opciones = response.requestOptions;
    _escribir(
      '← ${response.statusCode} ${opciones.method} ${opciones.path} '
          '(${_milisegundos(opciones)} ms)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final opciones = err.requestOptions;
    final codigo = err.response?.statusCode;
    final conCodigo = codigo == null ? '' : ' $codigo';
    _escribir(
      '✗ ${err.type.name}$conCodigo ${opciones.method} ${opciones.path} '
          '(${_milisegundos(opciones)} ms)',
    );
    handler.next(err);
  }

  int _milisegundos(RequestOptions opciones) {
    final cronometro = opciones.extra[_claveCronometro];
    return cronometro is Stopwatch ? cronometro.elapsedMilliseconds : 0;
  }
}
