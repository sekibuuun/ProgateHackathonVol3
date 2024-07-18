import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _loginState = 'Not logged in';

  _changeLoginState() {
    setState(() {
      _loginState = 'Logged in';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login state: $_loginState'),
            ElevatedButton(
              onPressed: () async {
                try {
                  await supabase.auth
                      .signInWithOAuth(
                    OAuthProvider.github,
                    redirectTo: "io.supabase.oauth://login-callback/",
                  )
                      .then((isSucceeded) {
                    // サインインできた場合Stateを更新
                    if (isSucceeded) {
                      _changeLoginState();
                    }
                  });
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
