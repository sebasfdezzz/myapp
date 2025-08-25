import 'package:flutter/material.dart';
import 'package:myapp/api_test_screen.dart';
import 'package:myapp/signin_screen.dart';
import 'package:myapp/signup_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/api_test': (context) => ApiTestScreen(),
      },
    );
  }
}
