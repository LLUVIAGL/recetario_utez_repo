import 'package:dio/dio.dart';

import '../dominio/falla_red.dart';

/// Convierte un error de Dio en una falla del dominio.
FallaRed traducirError(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => const TiempoAgotado(),
    DioExceptionType.badResponse => _desdeCodigo(e.response?.statusCode ?? 0),
    DioExceptionType.unknown =>
    e.error is FormatException
        ? const RespuestaInvalida()
        : const SinConexion(),
    DioExceptionType.badCertificate ||
    DioExceptionType.cancel ||
    DioExceptionType.connectionError => const SinConexion(),
  };
}

FallaRed _desdeCodigo(int codigo) =>
    codigo >= 500 ? ErrorDelServidor(codigo) : PeticionRechazada(codigo);