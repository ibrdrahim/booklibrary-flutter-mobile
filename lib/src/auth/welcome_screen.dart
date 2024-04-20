import 'package:flutter/material.dart';
import 'package:flutter_booklibrary/src/auth/login_screen.dart';
import 'package:flutter_booklibrary/src/auth/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to Your App",
                style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
