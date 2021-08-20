import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news/services/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: FloatingActionButton.extended(
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvder>(context, listen: false);
            provider.googleLogin();
          },
          icon: SvgPicture.asset(
            'assets/icons/google_logo.svg',
            width: 32,
            height: 32,
          ),
          label: Text("Sign in with Google"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}
