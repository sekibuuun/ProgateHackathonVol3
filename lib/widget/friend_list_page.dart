import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progate03/entity/user.dart';
import 'package:progate03/global.dart';
import 'package:progate03/repository/login_user_repository.dart';
import 'package:progate03/widget/landing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:url_launcher/url_launcher.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  late StreamSubscription<AuthState> _authSubscription;
  File? _newIconFile;

  setImage(XFile? photo) {
    if (photo != null) {
      setState(() {
        _newIconFile = File(photo.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
        final event = data.event;

        switch (event) {
          case AuthChangeEvent.signedOut:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
            break;

          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // example friend names
    final loginUserRepository = LoginUserRepository(supabase: supabase);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Friend List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GridView.count(
          padding: const EdgeInsets.only(top: 8),
          crossAxisCount: 3,
          children: loginUserRepository.friends
              .map((friend) => Column(
                    children: [
                      GestureDetector(
                        onTap: () => {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                UserDetailDialog(user: friend),
                          )
                        },
                        child: CircleAvatar(
                          radius: constraints.maxWidth / 8,
                          backgroundImage: Image.network(
                            friend.iconUrl,
                            fit: BoxFit.fill,
                          ).image,
                        ),
                      ),
                      Text(friend.name,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            // カメラを起動して写真を撮影
            final ImagePicker picker = ImagePicker();
            setImage(await picker.pickImage(source: ImageSource.camera));
          },
          child: const FaIcon(FontAwesomeIcons.camera),
        ),
      ),
    );
  }
}

class UserDetailDialog extends StatelessWidget {
  const UserDetailDialog({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Dialog(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CircleAvatar(
                    radius: constraints.maxWidth / 7,
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
                        debugPrint(
                            'Could not launch ${snsAccount.uri.toString()}');
                      }
                    },
                  ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
