class ArticleData {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String? author;
  final String sourceName;
  final String sourceId;
  ArticleData({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    this.author,
    required this.sourceName,
    required this.sourceId,
  });
  factory ArticleData.fromJson(Map<String, dynamic> json) {
    return ArticleData(
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"] ?? "",
      publishedAt: json["publishedAt"] ?? "",
      content: json["content"] ?? "",
      author: json["author"],
      sourceName: json["source"]?["name"] ?? "",
      sourceId: json["source"]?["id"] ?? "",
    );
  }
}
