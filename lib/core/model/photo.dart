typedef Json = Map<String, dynamic>;

class Photo {
  final String author;
  final String url;

  Photo({
    required this.author,
    required this.url,
  });

  factory Photo.fromJson(Json json) {
    return Photo(
      author: json['author'],
      url: json['download_url'],
    );
  }
}
