import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:progate03/entity/user.dart';

class LoginUserRepository {
  final SupabaseClient _supabase;

  const LoginUserRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  List<User> get friends => [
        // this data is dummy!!!!
        User.dummy(
          id: '1',
          name: 'Alice',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
          githubUrl: 'https://github.com/EringiShimeji',
          xUrl: 'https://x.com/',
        ),
        User.dummy(
          id: '2',
          name: 'Bob',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '3',
          name: 'Charlie',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '4',
          name: 'David',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '5',
          name: 'Eve',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '6',
          name: 'Frank',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '7',
          name: 'Gary',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '8',
          name: 'Harry',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '9',
          name: 'Ivy',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '10',
          name: 'Jack',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '11',
          name: 'Kim',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '12',
          name: 'Lily',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '13',
          name: 'Mike',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '14',
          name: 'Nancy',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '15',
          name: 'Oscar',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '16',
          name: 'Peter',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '17',
          name: 'Queen',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '18',
          name: 'Rose',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '19',
          name: 'Sam',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '20',
          name: 'Tom',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '21',
          name: 'Uma',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '22',
          name: 'Vicky',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '23',
          name: 'Will',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '24',
          name: 'Xavier',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '25',
          name: 'Yvonne',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
        User.dummy(
          id: '26',
          name: 'Zack',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
        ),
      ];

  addFriend({
    required File selfie,
  }) {
    // ここで写真をアップロードして、顔認識させる
  }
}
