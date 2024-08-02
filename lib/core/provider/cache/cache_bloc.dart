import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/core/service/cache_service.dart';

part 'cache_event.dart';
part 'cache_state.dart';

class CacheBloc extends Bloc<CacheEvent, CacheState> {
  CacheBloc()
      : _cacheServiceImpl = CacheServiceImpl(),
        super(CacheState.initial()) {
    on<CacheEvent>((event, emit) async {
      switch (event.event) {
        case CacheEvents.startFetchCachedPhotos:
          await _onStartFetchCachedPhotos(emit);
          break;
        default:
      }
    });
  }

  Future<void> _onStartFetchCachedPhotos(Emitter<CacheState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await _cacheServiceImpl.get();
    final cachedPhotos = List<String>.from(data);
    emit(state.copyWith(isLoading: false, photos: cachedPhotos));
  }

  late final CacheServiceImpl _cacheServiceImpl;
}
