import 'package:flutter/material.dart';
import 'auth.dart';
import 'logs.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  bool _awaitingCode = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Full Name'),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _signUp,
          child: const Text('Sign Up'),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }

  Widget _buildCodeForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Enter the 6-digit confirmation code sent to your email'),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: 'Confirmation Code'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _confirmCode,
          child: const Text('Confirm'),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }

Future<void> _signUp() async {
  setState(() => _error = null);
  final email = _emailController.text.trim();
  final password = _passwordController.text;
  final name = _nameController.text.trim();

  await traceInfo('SignUp', 'Attempting sign up for $email');
  final signedUp = await Auth.signUp(email, password, name);
  if (signedUp) {
    await traceInfo(
        'SignUp', 'Sign up successful for $email, awaiting confirmation code');
    setState(() => _awaitingCode = true);
  } else {
    await traceError('SignUp', 'Sign up failed for $email');
  }
}


  Future<void> _confirmCode() async {
    setState(() => _error = null);
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();

    await traceInfo('ConfirmSignUp', 'Attempting confirmation for $email');
    final confirmed = await Auth.confirmSignUp(email, code);
    if (confirmed) {
      await traceInfo('ConfirmSignUp', 'Confirmation successful for $email');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } else {
      await traceError(
          'ConfirmSignUp', 'Confirmation failed for $email');
    }
  }
}
