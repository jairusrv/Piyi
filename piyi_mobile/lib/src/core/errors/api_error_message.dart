import 'package:dio/dio.dart';

class ApiErrorMessage {
  const ApiErrorMessage._();

  static String fromObject(
    Object error, {
    String fallback = 'Ocurrio un error.',
  }) {
    if (error is DioException) {
      return fromDio(error, fallback: fallback);
    }

    final text = error.toString();

    if (text.contains('SocketException') ||
        text.contains('Connection refused')) {
      return 'No se pudo conectar con el servidor.';
    }

    if (text.contains('No route to host')) {
      return 'No se pudo llegar al servidor.';
    }

    if (text.contains('Exception') || text.contains('StackTrace')) {
      return fallback;
    }

    return text.isEmpty ? fallback : text;
  }

  static String fromDio(
    DioException error, {
    String fallback = 'Ocurrio un error.',
  }) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (data is Map && data['error'] != null) {
      return data['error'].toString();
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return 'No se pudo conectar con el servidor.';
      case DioExceptionType.badResponse:
        if (statusCode == 400) {
          return 'Revisa los datos e intenta de nuevo.';
        }
        if (statusCode == 401) {
          return 'Correo o contraseña incorrectos.';
        }
        if (statusCode == 403) {
          return 'No tienes permisos.';
        }
        if (statusCode == 404) {
          return 'No encontramos la informacion solicitada.';
        }
        if (statusCode == 500) {
          return 'El servidor tuvo un problema interno.';
        }
        return 'No pudimos completar la solicitud.';
      case DioExceptionType.cancel:
        return 'La solicitud fue cancelada.';
      case DioExceptionType.badCertificate:
        return 'No se pudo validar la conexion segura.';
      case DioExceptionType.unknown:
        return fallback;
    }
  }
}
