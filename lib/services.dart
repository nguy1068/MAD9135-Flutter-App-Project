//services.dart
//HTTP helper and API services

import 'package:http/http.dart' as http;
import 'dart:convert';

// Create HttpHelper class
class HttpHelper {
  // Define base URL for API
  static const String baseUrl = 'https://movie-night-api.onrender.com';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbApiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTNjZGZlZDVlMmI5ZDMzZTkxZjZlZDIyMWVmYmQ3NSIsIm5iZiI6MTY5OTg4ODMwMi42MDMwMDAyLCJzdWIiOiI2NTUyM2NhZTA4MTZjNzAxMzdlNzYxZTciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.rLazRt4_A_OLbBYlDp7B_AIVN7oqTIjVJwFJokaBumc';

  // Implement startSession method
  Future<dynamic> startSession(String deviceId) async {
    final response = await http.get(Uri.parse('$baseUrl/start-session?deviceId=$deviceId'));
    return json.decode(response.body);
  }

  // Implement joinSession method
  Future<dynamic> joinSession(String deviceId, int code) async {
    final response = await http.get(Uri.parse('$baseUrl/join-session?deviceId=$deviceId&code=$code'));
    return json.decode(response.body);
  }

  // Implement voteMovie method
  Future<dynamic> voteMovie(String sessionId, int movieId, bool vote) async {
    final response = await http.get(Uri.parse('$baseUrl/vote-movie?sessionId=$sessionId&movieId=$movieId&vote=$vote'));
    return json.decode(response.body);
  }

  // Implement fetchMovies method
  Future<List<Map<String, dynamic>>> fetchMovies(int page) async {
    final response = await http.get(Uri.parse('$tmdbBaseUrl/movie/popular?api_key=$tmdbApiKey&page=$page'));
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}
