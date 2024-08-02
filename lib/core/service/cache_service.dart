import 'package:photo_editor/core/boxes.dart';

abstract interface class CacheService {
  Future<void> put(String key, dynamic value);
  Future<List<String>> get();
}

class CacheServiceImpl implements CacheService {
  CacheServiceImpl() {
    _boxes = Boxes();
  }

  @override
  Future<List<String>> get() async {
    return List<String>.from(_boxes.photos.values);
  }

  @override
  Future<void> put(String key, dynamic value) async {
    await _boxes.photos.put(key, value);
  }

  late Boxes _boxes;
}
