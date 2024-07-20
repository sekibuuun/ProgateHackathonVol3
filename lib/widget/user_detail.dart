import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progate03/entity/user.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key, required this.user, this.radius = 50});

  final User user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: Image.network(
                user.iconUrl,
                fit: BoxFit.fill,
              ).image,
            )),
        Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (final snsAccount in user.snsAccounts)
            IconButton(
              icon: FaIcon(snsAccount.icon),
              onPressed: () async {
                if (!await launchUrl(snsAccount.uri)) {
                  debugPrint('Could not launch ${snsAccount.uri.toString()}');
                }
              },
            ),
        ]),
      ],
    );
  }
}
