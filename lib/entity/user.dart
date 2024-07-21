import 'package:progate03/entity/sns_account.dart';

class User {
  final String id;
  final String name;
  final String iconUrl;
  final SnsAccount? x;
  final SnsAccount? github;
  final List<SnsAccount> snsAccounts;

  const User({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.x,
    this.github,
    this.snsAccounts = const [],
  });

  factory User.of({
    String id = '1',
    String name = 'Alice',
    String iconUrl = 'https://randomuser.me/api/portraits',
    String? githubUrl,
    String? xUrl,
  }) {
    final snsAccounts = <SnsAccount>[];
    final github = githubUrl != null ? SnsAccount.github(githubUrl) : null;
    final x = xUrl != null ? SnsAccount.x(xUrl) : null;

    if (github != null) {
      snsAccounts.add(github);
    }
    if (x != null) {
      snsAccounts.add(x);
    }
    return User(
      id: id,
      name: name,
      iconUrl: iconUrl,
      x: x,
      github: github,
      snsAccounts: snsAccounts,
    );
  }

  factory User.fromJson(user) {
    return User.of(
      id: user['id'],
      name: user['user_name'],
      iconUrl: user['face_img_uri'],
      githubUrl: user['github_url'],
      xUrl: user['x_url'],
    );
  }
}
