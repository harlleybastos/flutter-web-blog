import 'package:flutter/material.dart';
import 'package:news/constants.dart';
import 'package:news/helper/constants.dart';
import 'package:news/providers/app.dart';
import 'package:news/providers/auth.dart';
import 'package:news/screens/login/login_auth.dart';
import 'package:news/screens/login/login_page.dart';
import 'package:news/screens/main/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppProvider()),
        ChangeNotifierProvider.value(value: AuthProvider.init())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blog Sons of Harllão',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kBgColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(backgroundColor: kPrimaryColor),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: kBodyTextColor),
            bodyText2: TextStyle(color: kBodyTextColor),
            headline5: TextStyle(color: kDarkBlackColor),
          ),
        ),
        home: BlogApp(),
      ),
    ),
  );
}

class BlogApp extends StatelessWidget {
  const BlogApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.Uninitialized:
        return CircularProgressIndicator();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return AuthenticationScreen();
      case Status.Authenticated:
        return MainScreen();
      default:
        return AuthenticationScreen();
    }
  }
}
