import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progate03/datasource/api_remote_data_source.dart';
import 'package:progate03/entity/user.dart';
import 'package:progate03/global.dart';
import 'package:progate03/repository/login_user_repository.dart';
import 'package:progate03/repository/selfie_repository.dart';
import 'package:progate03/widget/landing_page.dart';
import 'package:progate03/widget/user_detail.dart';
import 'package:progate03/widget/user_detail_dialog.dart';
import 'package:progate03/widget/user_editable_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  late StreamSubscription<AuthState> _authSubscription;
  File? _selfie;
  bool _isProgressVisible = true;
  late List<User> _friends;
  late LoginUserRepository loginUserRepository;
  final selfieRepository = SelfieRepository();

  setSelfie(XFile? photo) {
    if (photo != null) {
      setState(() {
        _selfie = File(photo.path);
      });
    }
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

  Future<void> setFriend() async {
    showProgress();
    final friends = await loginUserRepository.friends;
    setState(() {
      _friends = friends;
    });
    hideProgress();
  }

  @override
  void initState() {
    super.initState();

    loginUserRepository = LoginUserRepository(
      supabase: supabase,
      apiRemoteDataSource: ApiRemoteDataSource(),
    );
    setFriend();
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
      body: LayoutBuilder(builder: (context, constraints) {
        if (_isProgressVisible) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child:
                  UserEditableProfile(loginUserRepository: loginUserRepository),
            ),
            Expanded(
              child: _friends.isEmpty
                  ? const Center(child: Text('No friends yet'))
                  : GridView.count(
                      padding: const EdgeInsets.only(top: 8),
                      crossAxisCount: 3,
                      children: _friends
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ],
                              ))
                          .toList()),
            ),
          ],
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            final picker = ImagePicker();
            setSelfie(await picker.pickImage(
                source: ImageSource.camera, imageQuality: 50));

            if (_selfie == null) return;

            showProgress();

            await loginUserRepository.addFriend(selfie: _selfie!).then(
              (newFriendList) async {
                hideProgress();
                if (newFriendList.length == 1) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          UserDetailDialog(user: newFriendList.first));
                }
                await selfieRepository.saveSelfie(_selfie!);
                await setFriend();
              },
            ).catchError((e) {
              hideProgress();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e),
              ));
            });
          },
          child: const FaIcon(FontAwesomeIcons.camera),
        ),
      ),
    );
  }
}
