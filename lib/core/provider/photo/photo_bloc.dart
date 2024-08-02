import 'package:bloc/bloc.dart';
import 'package:photo_editor/core/model/photo.dart';
import 'package:photo_editor/core/service/api_service.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc()
      : _service = ApiService.instance,
        super(PhotoState.initial()) {
    on<PhotoEvent>((event, emit) async {
      switch (event.event) {
        case PhotoEvents.startFetchPhotos:
          await _onStartFetchPhotos(emit);
          break;
        default:
      }
    });
  }
  Future<void> _onStartFetchPhotos(Emitter<PhotoState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final photos = await _service.fetchPhotos();
      emit(state.copyWith(isLoading: false, photos: photos, event: PhotoEvents.successFetchPhotos));
    } catch (e) {
      emit(state.copyWith(isLoading: false, event: PhotoEvents.failureFetchPhotos));
    }
  }

  late final ApiService _service;
}
