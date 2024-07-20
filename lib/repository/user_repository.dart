import 'dart:io';

import 'package:progate03/datasource/api_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient _supabase;

  const UserRepository({
    required SupabaseClient supabase,
  }) : _supabase = supabase;

  Future<void> createUser(
      {required String username,
      required File iconImage,
      void Function()? onSuccess}) async {
    final filePath =
        "public/${DateTime.now().toIso8601String()}.${iconImage.path}";
    await _supabase.storage.from('test_face_img').upload(filePath, iconImage);
    final iconUrl =
        _supabase.storage.from("test_face_img").getPublicUrl(filePath);
    await ApiRemoteDataSource().createUser(
      id: _supabase.auth.currentUser!.id,
      username: username,
      iconUrl: iconUrl,
    );
    onSuccess?.call();
  }
}
