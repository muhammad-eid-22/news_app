import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/artical_data.dart';
import '../models/source_data_model.dart';
import 'api_constants.dart';
import 'end_points.dart';

class NetworkHandler {
  static Future<List<SourceData>> getAllSources(String categoryID) async {
    try {
      Map<String, dynamic> queryParameters = {
        "apiKey": ApiConstants.apiKey,
        "category": categoryID,
      };
      final response = await http.get(
        Uri.https(ApiConstants.baseURL, EndPoints.allSources, queryParameters),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        SourceDataModel sourceDataModel = SourceDataModel.fromJson(data);
        return sourceDataModel.sources;
      } else {
        throw Exception("something went wrong");
      }
    } catch (error) {
      throw Exception("something went wrong");
    }
  }

  static Future<List<ArticleData>> getAllArticles(String sourceId) async {
    try {
      Map<String, dynamic> queryParameters = {
        "apiKey": ApiConstants.apiKey,
        "sources": sourceId,
      };
      final response = await http.get(
        Uri.https(ApiConstants.baseURL, EndPoints.allArticles, queryParameters),
      );
      List<ArticleData> articles = [];
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var element in data["articles"]) {
          ArticleData articleData = ArticleData.fromJson(element);
          articles.add(articleData);
        }
        return articles;
      } else {
        throw Exception("something went wrong");
      }
    } catch (error) {
      throw Exception("something went wrong");
    }
  }

  static Future<List<ArticleData>> searchArticles(
    String query, {
    String? sortBy,
    String? language,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "apiKey": ApiConstants.apiKey,
        "q": query,
        if (sortBy != null) "sortBy": sortBy,
        if (language != null) "language": language,
      };
      final response = await http.get(
        Uri.https(ApiConstants.baseURL, EndPoints.allArticles, queryParameters),
      );
      List<ArticleData> articles = [];
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var element in data["articles"]) {
          ArticleData articleData = ArticleData.fromJson(element);
          articles.add(articleData);
        }
        return articles;
      } else {
        throw Exception("something went wrong");
      }
    } catch (error) {
      throw Exception("something went wrong");
    }
  }

  static Future<List<ArticleData>> getTopHeadlines({
    String? category,
    String? country,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "apiKey": ApiConstants.apiKey,
        if (category != null) "category": category,
        if (country != null) "country": country,
      };
      final response = await http.get(
        Uri.https(
          ApiConstants.baseURL,
          EndPoints.topHeadlines,
          queryParameters,
        ),
      );
      List<ArticleData> articles = [];
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var element in data["articles"]) {
          ArticleData articleData = ArticleData.fromJson(element);
          articles.add(articleData);
        }
        return articles;
      } else {
        throw Exception("something went wrong");
      }
    } catch (error) {
      throw Exception("something went wrong");
    }
  }
}
