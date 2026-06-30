import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'pet_health_models.dart';

final petHealthRepositoryProvider = Provider<PetHealthRepository>((ref) {
  return PetHealthRepository(ref.watch(dioProvider));
});

class PetHealthRepository {
  PetHealthRepository(this._dio);

  final Dio _dio;

  Future<PetQrCode> generateQr(String petId) async {
    final response = await _dio.post('/api/pets/$petId/qr');
    return PetQrCode.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PetQrCode?> getQr(String petId) async {
    try {
      final response = await _dio.get('/api/pets/$petId/qr');
      return PetQrCode.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<List<PetVaccine>> getVaccines(String petId) async {
    final response = await _dio.get('/api/pets/$petId/vaccines');
    final data = response.data as List<dynamic>;
    return data.map((x) => PetVaccine.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<List<PetReminder>> getReminders(String petId) async {
    final response = await _dio.get('/api/pets/$petId/reminders');
    final data = response.data as List<dynamic>;
    return data.map((x) => PetReminder.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<List<PetAppointment>> getAppointments(String petId) async {
    final response = await _dio.get('/api/pets/$petId/appointments');
    final data = response.data as List<dynamic>;
    return data.map((x) => PetAppointment.fromJson(x as Map<String, dynamic>)).toList();
  }
}
