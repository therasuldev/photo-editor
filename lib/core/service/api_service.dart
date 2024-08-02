import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:photo_editor/core/service/cache_service.dart';

import '../model/photo.dart';

class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ?? ApiService._();

  late Dio _dio;

  ApiService._() {
    _dio = Dio(BaseOptions(baseUrl: 'https://picsum.photos/v2'));
  }

  Future<List<Photo>> fetchPhotos() async {
    try {
      final response = await _dio.get('/list');
      if (response.statusCode == 200) {
        final data = response.data as List;
        final result = List<Photo>.from(data.map((photoJson) => Photo.fromJson(photoJson)));
        return result;
      }
      return [];
    } on DioException catch (exp) {
      log(exp.message.toString());
      return [];
    }
  }

  Future<List> fetchEditedPhotos() async {
    try {
      final editedPhotoUrls = await CacheServiceImpl().get();
      return editedPhotoUrls;
    } catch (e) {
      return [];
    }
  }
}
