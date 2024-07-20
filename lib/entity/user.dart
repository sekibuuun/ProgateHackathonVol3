import 'package:progate03/entity/sns_account.dart';

class User {
  final String id;
  final String name;
  final String iconUrl;
  final List<SnsAccount> snsAccounts;

  const User({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.snsAccounts = const [],
  });

  factory User.dummy({
    String id = '1',
    String name = 'Alice',
    String iconUrl = 'https://randomuser.me/api/portraits',
    String? githubUrl,
    String? xUrl,
  }) {
    final snsAccounts = <SnsAccount>[];
    if (githubUrl != null) {
      snsAccounts.add(SnsAccount.github(githubUrl));
    }
    if (xUrl != null) {
      snsAccounts.add(SnsAccount.x(xUrl));
    }
    return User(
      id: id,
      name: name,
      iconUrl: iconUrl,
      snsAccounts: snsAccounts,
    );
  }

  factory User.fromJson(user) {
    final snsAccounts = <SnsAccount>[];
    if (user['github_url'] != null) {
      snsAccounts.add(SnsAccount.github(user['github_url']));
    }
    if (user['x_url'] != null) {
      snsAccounts.add(SnsAccount.x(user['x_url']));
    }
    return User(
      id: user['id'],
      name: user['user_name'],
      iconUrl: user['face_img_uri'],
      snsAccounts: snsAccounts,
    );
  }
}
