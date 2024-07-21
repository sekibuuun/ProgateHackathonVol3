import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progate03/datasource/api_remote_data_source.dart';
import 'package:progate03/entity/sns_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:progate03/entity/user.dart';

class LoginUserRepository {
  final SupabaseClient _supabase;
  final ApiRemoteDataSource _apiRemoteDataSource;

  const LoginUserRepository({
    required SupabaseClient supabase,
    required ApiRemoteDataSource apiRemoteDataSource,
  })  : _supabase = supabase,
        _apiRemoteDataSource = apiRemoteDataSource;

  Future<User> get user async {
    return await _apiRemoteDataSource.getUser(
      id: _supabase.auth.currentUser!.id,
    );
  }

  Future<List<User>> get friends async {
    return await _apiRemoteDataSource.getFriends(
      id: _supabase.auth.currentUser!.id,
    );
  }

  Future<void> addSnsAccount(String url) async {
    var user = await this.user;

    if (url.startsWith("https://github.com")) {
      await _apiRemoteDataSource.updateUser(User.of(
        id: user.id,
        name: user.name,
        iconUrl: user.iconUrl,
        githubUrl: url,
        xUrl: user.x?.uri.toString(),
      ));
    } else if (url.startsWith("https://x.com") ||
        url.startsWith("https://twitter.com")) {
      await _apiRemoteDataSource.updateUser(User.of(
        id: user.id,
        name: user.name,
        iconUrl: user.iconUrl,
        githubUrl: user.github?.uri.toString(),
        xUrl: url,
      ));
    } else {
      return Future.error("Invalid URL");
    }
  }

  Future<void> deleteSnsAccount(SnsAccount snsAccount) async {
    final user = await this.user;
    await _apiRemoteDataSource.createUser(
      id: user.id,
      username: user.name,
      iconUrl: user.iconUrl,
      githubUrl: snsAccount.icon == FontAwesomeIcons.github
          ? ""
          : user.github?.uri.toString() ?? "",
      xUrl: snsAccount.icon == FontAwesomeIcons.xTwitter
          ? ""
          : user.x?.uri.toString() ?? "",
    );
  }

  // 写真をアップロードして、認識したユーザーを返す
  Future<List<User>> addFriend({
    required File selfie,
  }) async {
    final newFriendList = await _apiRemoteDataSource.uploadSelfie(
      id: _supabase.auth.currentUser!.id,
      selfie: selfie,
    );
    return newFriendList;
  }
}

class DummyLoginUserRepository extends LoginUserRepository {
  DummyLoginUserRepository({
    required super.supabase,
    required super.apiRemoteDataSource,
  });

  final _friends = [
    // this data is dummy!!!!
    User.of(
      id: '1',
      name: 'Alice',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
      githubUrl: 'https://github.com/EringiShimeji',
      xUrl: 'https://x.com/',
    ),
    User.of(
      id: '2',
      name: 'Bob',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '3',
      name: 'Charlie',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '4',
      name: 'David',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '5',
      name: 'Eve',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '6',
      name: 'Frank',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '7',
      name: 'Gary',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '8',
      name: 'Harry',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '9',
      name: 'Ivy',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '10',
      name: 'Jack',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '11',
      name: 'Kim',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '12',
      name: 'Lily',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '13',
      name: 'Mike',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '14',
      name: 'Nancy',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '15',
      name: 'Oscar',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '16',
      name: 'Peter',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '17',
      name: 'Queen',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '18',
      name: 'Rose',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '19',
      name: 'Sam',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '20',
      name: 'Tom',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '21',
      name: 'Uma',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '22',
      name: 'Vicky',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '23',
      name: 'Will',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '24',
      name: 'Xavier',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '25',
      name: 'Yvonne',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
    User.of(
      id: '26',
      name: 'Zack',
      iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
    ),
  ];

  User _user = User.of(
    id: '0',
    name: 'Dummy User',
    iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
  );

  @override
  Future<User> get user async =>
      await Future.delayed(const Duration(seconds: 1), () => _user);

  @override
  Future<List<User>> get friends async => await Future.delayed(
        const Duration(seconds: 1),
        () => _friends,
      );

  @override
  Future<List<User>> addFriend({
    required File selfie,
  }) async {
    final newFriendList = await Future.delayed(
      const Duration(seconds: 1),
      () => [
        User.of(
          id: '27',
          name: 'New Friend',
          iconUrl: 'https://avatars.githubusercontent.com/u/59910028?v=4',
          githubUrl: 'https://github.com/EringiShimeji',
          xUrl: 'https://x.com/',
        ),
      ],
      // () => Future.error('Faces has not been detected. Try again.'),
    );
    _friends.addAll(newFriendList);

    return newFriendList;
  }

  @override
  Future<void> addSnsAccount(String url) async {
    final user = await this.user;

    if (url.startsWith("https://github.com")) {
      user.snsAccounts.add(SnsAccount.github(url));
    } else if (url.startsWith("https://x.com") ||
        url.startsWith("https://twitter.com")) {
      user.snsAccounts.add(SnsAccount.x(url));
    } else {
      return Future.error("Invalid URL");
    }
  }
}
