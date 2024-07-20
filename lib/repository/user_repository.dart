import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient _supabase;

  const UserRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  Future<void> createUser(
      {required String username,
      required File iconImage,
      void Function()? onSuccess}) async {
    await Future.delayed(const Duration(seconds: 1));
    onSuccess?.call();
  }
}
