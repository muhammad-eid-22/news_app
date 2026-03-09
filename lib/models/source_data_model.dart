class SourceDataModel {
  final String status;
  final List<SourceData> sources;

  SourceDataModel({required this.status, required this.sources});

  factory SourceDataModel.fromJson(Map<String, dynamic> json) {
    return SourceDataModel(
      status: json["status"],
      sources: List.from(
        json["sources"],
      ).map((x) => SourceData.fromJson(x)).toList(),
    );
  }
}

class SourceData {
  final String id;
  final String name;
  final String description;
  final String url;
  final String category;
  final String language;
  final String country;

  SourceData({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    required this.language,
    required this.country,
  });

  factory SourceData.fromJson(Map<String, dynamic> json) {
    return SourceData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      url: json["url"],
      category: json["category"],
      language: json["language"],
      country: json["country"],
    );
  }
}
