class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String? summary;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.summary,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      imageUrl: json['background_image'],
      summary: json['summary'],
    );
  }
}
