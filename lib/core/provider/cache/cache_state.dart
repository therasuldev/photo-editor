part of 'cache_bloc.dart';

class CacheState {
  final bool isLoading;
  final CacheEvents event;
  final List<String> photos;

  CacheState({
    required this.isLoading,
    required this.event,
    required this.photos,
  });

  CacheState copyWith({
    bool? isLoading,
    CacheEvents? event,
    List<String>? photos,
  }) {
    return CacheState(
      isLoading: isLoading ?? this.isLoading,
      event: event ?? this.event,
      photos: photos ?? this.photos,
    );
  }

  factory CacheState.initial() {
    return CacheState(
      isLoading: false,
      event: CacheEvents.initialFetchCachedPhotos,
      photos: [],
    );
  }
}
