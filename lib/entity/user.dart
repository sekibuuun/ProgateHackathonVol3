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
    return User(
      id: user['id'],
      name: user['name'],
      iconUrl: user['iconUrl'],
      snsAccounts: user['snsAccounts'],
    );
  }
}
