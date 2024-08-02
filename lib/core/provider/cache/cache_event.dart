part of 'cache_bloc.dart';

enum CacheEvents {
  initialFetchCachedPhotos,
  startFetchCachedPhotos,
  successFetchCachedPhotos,
  failureFetchCachedPhotos,
}

class CacheEvent {
  CacheEvents? event;

  CacheEvent.initialFetchCachedPhotos() {
    event = CacheEvents.initialFetchCachedPhotos;
  }
  CacheEvent.startFetchCachedPhotos() {
    event = CacheEvents.startFetchCachedPhotos;
  }
  CacheEvent.successFetchCachedPhotos() {
    event = CacheEvents.successFetchCachedPhotos;
  }
  CacheEvent.failureFetchCachedPhotos() {
    event = CacheEvents.failureFetchCachedPhotos;
  }
}
