import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/ui/auth/auth_page.dart';
import 'package:salon/ui/bottom_navigator/bottom_navigator.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? BottomNavigator() : AuthPage();
  }
}
