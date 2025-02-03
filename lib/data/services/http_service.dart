import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final http.Client _client;

  HttpService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<String> getDataFromUrl(String url) async {
    final response = await _client.get(Uri.parse(url));
    return response.body;
  }

  Future<Uint8List> getByteArrayFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch image');
    }
  }
}
