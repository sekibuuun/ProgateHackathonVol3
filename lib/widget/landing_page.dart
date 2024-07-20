import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progate03/datasource/api_remote_data_source.dart';
import 'package:progate03/global.dart';
import 'package:progate03/repository/user_repository.dart';
import 'package:progate03/widget/friend_list_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _didPressedCreateAccount = false;
  late StreamSubscription<AuthState> _authSubscription;
  File? _newIconFile;
  String _newUsername = "";
  final userRepository = UserRepository(
    supabase: supabase,
    apiRemoteDataSource: ApiRemoteDataSource(),
  );

  setImage(XFile? photo) {
    if (photo != null) {
      setState(() {
        _newIconFile = File(photo.path);
      });
    }
  }

  setUsername(String username) {
    setState(() {
      _newUsername = username;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _authSubscription = supabase.auth.onAuthStateChange.listen((data) async {
        final event = data.event;

        switch (event) {
          case AuthChangeEvent.signedIn:
            {
              if (_didPressedCreateAccount) {
                await userRepository.createUser(
                    username: _newUsername,
                    iconImage: _newIconFile!,
                    onSuccess: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const FriendListPage();
                        }),
                      );
                    });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const FriendListPage();
                  }),
                );
              }
            }
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
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SizedBox(
            width: constraints.maxWidth / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () async {
                        // カメラを起動して写真を撮影
                        final picker = ImagePicker();
                        setImage(
                            await picker.pickImage(source: ImageSource.camera));
                      },
                      child: CircleAvatar(
                        radius: constraints.maxWidth / 8,
                        backgroundImage: _newIconFile != null
                            ? FileImage(_newIconFile!)
                            : null,
                        child: _newIconFile == null
                            ? const FaIcon(FontAwesomeIcons.camera)
                            : null,
                      )),
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: setUsername,
                ),
                ElevatedButton(
                  onPressed: _newIconFile != null && _newUsername.isNotEmpty
                      ? () async {
                          setState(() {
                            _didPressedCreateAccount = true;
                          });
                          await supabase.auth.signInWithOAuth(
                            OAuthProvider.github,
                            redirectTo: "io.supabase.oauth://login-callback/",
                          );
                        }
                      : null,
                  child: const Text('Create Account with GitHub'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('or', style: Theme.of(context).textTheme.bodyMedium),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await supabase.auth.signInWithOAuth(
                        OAuthProvider.github,
                        redirectTo: "io.supabase.oauth://login-callback/",
                      );
                    } on AuthException catch (error) {
                      debugPrint(error.toString());
                    } catch (error) {
                      debugPrint(error.toString());
                    }
                  },
                  child: const Text('Sign in with GitHub'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
