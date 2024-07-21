import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progate03/entity/user.dart';
import 'package:progate03/repository/login_user_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class UserEditableProfile extends StatefulWidget {
  const UserEditableProfile({
    super.key,
    required this.loginUserRepository,
  });

  final LoginUserRepository loginUserRepository;

  @override
  State<UserEditableProfile> createState() => _UserEditableProfileState();
}

class _UserEditableProfileState extends State<UserEditableProfile> {
  final double radius = 50;
  bool _isProgressVisible = true;
  late User _user;
  String _snsAccountUrl = '';

  setSnsAccountUrl(String url) {
    setState(() {
      _snsAccountUrl = url;
    });
  }

  showProgress() {
    setState(() {
      _isProgressVisible = true;
    });
  }

  hideProgress() {
    setState(() {
      _isProgressVisible = false;
    });
  }

  Future<void> setUser() async {
    showProgress();
    final user = await widget.loginUserRepository.user;
    setState(() {
      _user = user;
    });
    hideProgress();
  }

  @override
  void initState() {
    super.initState();

    setUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_isProgressVisible) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CircleAvatar(
              radius: radius,
              child: const FaIcon(FontAwesomeIcons.userLarge),
            )),
        Text("Loading...", style: Theme.of(context).textTheme.headlineSmall),
      ]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: Image.network(
                _user.iconUrl,
                fit: BoxFit.fill,
              ).image,
            )),
        Text(_user.name, style: Theme.of(context).textTheme.headlineSmall),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (final snsAccount in _user.snsAccounts)
            IconButton(
              icon: FaIcon(snsAccount.icon),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete SNS Account'),
                    content: const Text(
                        'Are you sure you want to delete this account?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await widget.loginUserRepository
                              .deleteSnsAccount(snsAccount)
                              .then((_) async {
                            Navigator.pop(context);
                            setUser();
                          });
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 10),
                    title: const Text('Add SNS Account'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'URL',
                          ),
                          onChanged: setSnsAccountUrl,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await widget.loginUserRepository
                                .addSnsAccount(_snsAccountUrl)
                                .then((_) async {
                              Navigator.pop(context);
                              await setUser();
                            });
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const FaIcon(FontAwesomeIcons.circlePlus),
          )
        ]),
      ],
    );
  }
}
