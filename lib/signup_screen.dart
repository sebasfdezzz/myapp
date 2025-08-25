import 'package:flutter/material.dart';
import 'package:myapp/auth.dart'; // Assuming auth.dart is in the same directory or accessible path

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
import 'package:flutter/material.dart';
import 'auth.dart';
import 'logs.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _awaitingCode = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _awaitingCode ? _buildCodeForm() : _buildSignUpForm(),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _signUp,
          child: Text('Sign Up'),
        ),
        if (_error != null) ...[
          SizedBox(height: 8),
          Text(_error!, style: TextStyle(color: Colors.red)),
        ],
      ],
    );
  }

  Widget _buildCodeForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Enter the 6-digit confirmation code sent to your email'),
        TextField(
          controller: _codeController,
          decoration: InputDecoration(labelText: 'Confirmation Code'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _confirmCode,
          child: Text('Confirm'),
        ),
        if (_error != null) ...[
          SizedBox(height: 8),
          Text(_error!, style: TextStyle(color: Colors.red)),
        ],
      ],
    );
  }

  void _signUp() async {
    setState(() => _error = null);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    await traceInfo('SignUp', 'Attempting sign up for $email');
    final error = await signUp(email, password);
    if (error == null) {
      await traceInfo('SignUp', 'Sign up successful for $email, awaiting confirmation code');
      setState(() => _awaitingCode = true);
    } else {
      await traceError('SignUp', 'Sign up failed for $email: $error');
      setState(() => _error = error);
    }
  }

  void _confirmCode() async {
    setState(() => _error = null);
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    await traceInfo('ConfirmSignUp', 'Attempting confirmation for $email');
    final error = await confirmSignUp(email, code);
    if (error == null) {
      await traceInfo('ConfirmSignUp', 'Confirmation successful for $email');
      // Go to sign in
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } else {
      await traceError('ConfirmSignUp', 'Confirmation failed for $email: $error');
      setState(() => _error = error);
    }
  }
}
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Auth _auth = Auth();

  void _signIn() {
    // You can access the email and password here if needed
    // String email = _emailController.text;
    // String password = _passwordController.text;

    _auth.signIn(); // Call the signIn method from Auth class
    // Add navigation or further logic after sign-in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}