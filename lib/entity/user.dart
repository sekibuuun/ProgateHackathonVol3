import 'package:progate03/entity/sns_account.dart';

class User {
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

  final String id;
  final String name;
  final String iconUrl;
  final List<SnsAccount> snsAccounts;
}
