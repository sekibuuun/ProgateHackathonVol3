import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progate03/entity/user.dart';

class ApiRemoteDataSource {
  Uri _uri(String endpoint) {
    return Uri.parse("${dotenv.env['API_URL']!}$endpoint");
  }

  Future<User> getUser({required String id}) async {
    final response = await http.get(_uri("/users/$id"));
    if (response.statusCode != 200) {
      return Future.error(json.decode(response.body)['detail']);
    }
    return User.fromJson(json.decode(response.body)[0]);
  }

  Future<void> updateUser(User user) async {
    http.patch(
      _uri("/users/${user.id}"),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: json.encode({
        'user_name': user.name,
        'github_url': user.github?.uri.toString() ?? "",
        'x_url': user.x?.uri.toString() ?? "",
        'face_img_uri': user.iconUrl,
      }),
    );
  }

  Future<void> createUser({
    required String id,
    required String username,
    required String iconUrl,
    String? githubUrl,
    String? xUrl,
  }) async {
    http.patch(
      _uri("/users/$id"),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: json.encode({
        'user_name': username,
        'github_url': githubUrl ?? "",
        'x_url': xUrl ?? "",
        'face_img_uri': iconUrl,
      }),
    );
  }

  Future<List<User>> uploadSelfie({
    required String id,
    required File selfie,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      _uri("/detect_faces/$id"),
    );
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      await selfie.readAsBytes(),
      filename: "${DateTime.now().toIso8601String()}.${selfie.path}",
    ));

    final stream = await request.send();

    return http.Response.fromStream(stream).then((response) {
      if (response.statusCode != 200) {
        return Future.error(json.decode(response.body)['detail']);
      }

      return json
          .decode(response.body)
          .map<User>((user) => User.fromJson(user))
          .toList();
    });
  }

  Future<List<User>> getFriends({
    required String id,
  }) async {
    final response = await http.get(_uri("/friends/$id"));
    print(response.statusCode);
    if (response.statusCode != 200) {
      return [];
    }
    return json.decode(response.body).map<User>((user) {
      print(user);
      return User.fromJson(user);
    }).toList();
  }
}
