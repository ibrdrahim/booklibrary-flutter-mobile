import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booklibrary/src/auth/forgot_password_screen.dart';
import 'package:flutter_booklibrary/src/auth/register_screen.dart';
import 'package:flutter_booklibrary/src/books/book_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookListScreen()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? "An error occurred";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => (value == null || !value.contains('@'))
                      ? "Enter a valid email"
                      : null,
                  onChanged: (value) => _email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => (value == null || value.length < 6)
                      ? "Password must be at least 6 characters long"
                      : null,
                  onChanged: (value) => _password = value,
                ),
                SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Text(_errorMessage,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                if (_isLoading) Center(child: CircularProgressIndicator()),
                if (!_isLoading)
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()));
                  },
                  child: Text("Forgot Password?"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterScreen()));
                  },
                  child: Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
