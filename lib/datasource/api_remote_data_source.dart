import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiRemoteDataSource {
  Future<void> createUser({
    required String id,
    required String username,
    required String iconUrl,
  }) async {
    http.patch(
      Uri.parse("${dotenv.env['API_URL']!}/users/$id"),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: json.encode({
        'user_name': username,
        'github_url': 'example.com',
        'x_url': 'example.com',
        'face_img_uri': iconUrl,
      }),
    );
  }
}
