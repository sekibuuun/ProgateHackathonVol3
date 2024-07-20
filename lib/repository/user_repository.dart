import 'dart:io';

import 'package:progate03/datasource/api_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient _supabase;
  final ApiRemoteDataSource _apiRemoteDataSource;

  const UserRepository({
    required SupabaseClient supabase,
    required ApiRemoteDataSource apiRemoteDataSource,
  })  : _supabase = supabase,
        _apiRemoteDataSource = apiRemoteDataSource;

  Future<void> createUser(
      {required String username,
      required File iconImage,
      void Function()? onSuccess}) async {
    final filePath =
        "public/${DateTime.now().toIso8601String()}.${iconImage.path}";
    await _supabase.storage.from('test_face_img').upload(filePath, iconImage);
    final iconUrl =
        _supabase.storage.from("test_face_img").getPublicUrl(filePath);
    await _apiRemoteDataSource.createUser(
      id: _supabase.auth.currentUser!.id,
      username: username,
      iconUrl: iconUrl,
    );
    onSuccess?.call();
  }
}
