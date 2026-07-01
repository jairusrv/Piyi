import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'upload_result.dart';

final uploadsRepositoryProvider = Provider<UploadsRepository>((ref) {
  return UploadsRepository(ref.watch(dioProvider));
});

class UploadsRepository {
  UploadsRepository(this._dio);

  final Dio _dio;

  Future<UploadResult> uploadImage(String filePath) async {
    final fileName = filePath.split('/').last.split('\\').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    final response = await _dio.post(
      '/api/uploads/images',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return UploadResult.fromJson(response.data as Map<String, dynamic>);
  }
}
