import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/ui/auth/auth_page.dart';
import 'package:salon/ui/bottom_navigator/bottom_navigator.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: markPrimaryColor,));
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? BottomNavigator() : AuthPage();
        }
      },
    );
    
  }
}
