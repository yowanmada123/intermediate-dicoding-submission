import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
      debugPrint('Error fetching image: $e');
      throw Exception('Failed to fetch image');
    }
  }

  Future<String> downloadAndSaveFile(String url, String fileName) async {
    try {
      final bytes = await getByteArrayFromUrl(url);

      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      debugPrint('File saved at: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Failed to download or save file: $e');
      throw Exception('Failed to download or save file');
    }
  }
}
