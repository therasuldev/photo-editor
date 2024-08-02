part of 'photo_bloc.dart';

class PhotoState {
  final bool isLoading;
  final PhotoEvents event;
  final List<Photo> photos;

  PhotoState({
    required this.isLoading,
    required this.event,
    required this.photos,
  });

  PhotoState copyWith({
    bool? isLoading,
    PhotoEvents? event,
    List<Photo>? photos,
  }) {
    return PhotoState(
      isLoading: isLoading ?? this.isLoading,
      event: event ?? this.event,
      photos: photos ?? this.photos,
    );
  }

  factory PhotoState.initial() {
    return PhotoState(isLoading: false, event: PhotoEvents.initialFetchPhotos, photos: []);
  }
}
