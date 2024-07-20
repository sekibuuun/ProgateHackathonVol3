import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progate03/entity/user.dart';
import 'package:progate03/repository/login_user_repository.dart';
import 'package:progate03/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: supabase.auth.currentUser != null
          ? const FriendListPage()
          : const LandingPage(),
    );
  }
}

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
  final userRepository = UserRepository(supabase: supabase);

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
        final session = data.session;

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
                        final ImagePicker picker = ImagePicker();
                        // ファイルを扱う処理は省略・・・
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

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  late StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();

    setState(() {
      _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
        final event = data.event;
        final session = data.session;

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
        ));
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

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Create Account'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await supabase.auth.signOut();
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
