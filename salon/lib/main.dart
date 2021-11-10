import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/providers/horarios.dart';
import 'package:salon/providers/procedimentos.dart';
import 'package:salon/ui/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Horarios>(
          create: (context) => Horarios('',[],[]),
          update: (context, auth, previous) => Horarios(
            auth.token ?? '',
            previous?.horarios ?? [],
            previous?.historico ?? [],
          )
        ),
        ChangeNotifierProvider(create: (context) => Procedimentos()),
      ],
      child: MyApp()
    )
  );
}
