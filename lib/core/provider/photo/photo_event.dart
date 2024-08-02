part of 'photo_bloc.dart';

enum PhotoEvents {
  initialFetchPhotos,
  startFetchPhotos,
  successFetchPhotos,
  failureFetchPhotos,
}

class PhotoEvent {
  PhotoEvents? event;
  dynamic payload;

  PhotoEvent.initialFetchPhotos() {
    event = PhotoEvents.initialFetchPhotos;
  }
  PhotoEvent.startFetchPhotos() {
    event = PhotoEvents.startFetchPhotos;
  }
  PhotoEvent.successFetchPhotos() {
    event = PhotoEvents.successFetchPhotos;
  }
  PhotoEvent.failureFetchPhotos() {
    event = PhotoEvents.failureFetchPhotos;
  }
}
