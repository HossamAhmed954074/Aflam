import 'package:aflam/core/models/movie_model.dart';
import 'package:aflam/core/secrets/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  Future<MovieModel> getTopRatedMovies() async {
    final response = await http.get(
      Uri.parse("${Secrets.baseUrl}/trending/all/day?api_key=${Secrets.apiKey}"),
    );
    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load movies");
    }
  }

  // get all movies by page
  Future<MovieModel> getAllMovies({int page = 1}) async {
    final response = await http.get(
      Uri.parse("${Secrets.baseUrl}/discover/movie?api_key=${Secrets.apiKey}&page=$page"),
    );
    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load movies");
    }
  }

  // search for movies
  Future<MovieModel> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse("${Secrets.baseUrl}/search/movie?api_key=${Secrets.apiKey}&query=$query"),
    );
    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
