import 'package:flutter/material.dart';
import 'package:myapp/api_test_screen.dart';
import 'package:myapp/flow_e2e_test.dart';
import 'package:myapp/signin_screen.dart';
import 'package:myapp/signup_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Auth App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StartScreen(),
      routes: {
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/api_test': (context) => ApiTestScreen(),
        '/e2e': (context) => E2EScreen(),
      },
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signin'),
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
