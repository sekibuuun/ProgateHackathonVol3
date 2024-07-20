import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progate03/entity/user.dart';
import 'package:progate03/repository/login_user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fkmcbcubjjureqksfdle.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZrbWNiY3Viamp1cmVxa3NmZGxlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjEzMDY2ODksImV4cCI6MjAzNjg4MjY4OX0.fLhHORze2zXx6Rj9MilXGZ80wodz-PaIuiNzJaQEJZw',
  );
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _loginState = 'Not logged in';
  StreamSubscription<AuthState>? _authSubscription;

  _changeLoginState(bool hasLoggedIn) {
    setState(() {
      _loginState = hasLoggedIn ? 'Logged in' : 'Not logged in';
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
        final event = data.event;

        switch (event) {
          case AuthChangeEvent.signedIn:
            _changeLoginState(true);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FriendListPage()),
            );
            break;

          case AuthChangeEvent.signedOut:
            _changeLoginState(false);
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

    if (_authSubscription != null) {
      _authSubscription!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login state: $_loginState'),
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
              child: const Text('Sign in with Github'),
            ),
            ElevatedButton(
              onPressed: () async {
                await supabase.auth.signOut();
              },
              child: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }
}

class FriendListPage extends StatelessWidget {
  const FriendListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // example friend names
    final loginUserRepository = LoginUserRepository(supabase: supabase);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Friend List'),
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
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    constraints.maxWidth / 8),
                                child: Image.network(
                                  friend.iconUrl,
                                  fit: BoxFit.fill,
                                )),
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
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(constraints.maxWidth / 7),
                        child: Image.network(
                          user.iconUrl,
                          fit: BoxFit.fill,
                        )),
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
