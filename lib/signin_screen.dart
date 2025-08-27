import 'package:flutter/material.dart';
import 'package:myapp/auth.dart';
import 'logs.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(onPressed: _signIn, child: Text('Sign In')),
            if (_error != null) ...[
              SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() => _error = null);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    await traceInfo('SignIn', 'Attempting sign in for $email');
    final signedIn = await Auth.signIn(email, password);
    if (signedIn) {
      await traceInfo('SignIn', 'Sign in successful for $email');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/e2e');
      }
    } else {
      await traceError('SignIn', 'Sign in failed for $email');
    }
  }
}
