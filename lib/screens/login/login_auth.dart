import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news/providers/app.dart';
import 'package:news/providers/auth.dart';
import 'package:news/screens/main/main_screen.dart';
import 'package:news/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blueGrey, Colors.indigo])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                width: 100,
                height: 100,
              ),
            ],
          ),
          CustomText(
            text: "Select authentication method",
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              appProvider.changeLoading();
              Map result = await authProvider.signInWithGoogle();
              bool success = result['success'];
              String message = result['message'];
              print(message);

              if (!success) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
                appProvider.changeLoading();
              } else {
                appProvider.changeLoading();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              }
            },
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        offset: Offset(2, 3),
                        blurRadius: 7)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [CustomText(text: "Use Google")],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
