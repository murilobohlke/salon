import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/_utils/app_routes.dart';
import 'package:salon/models/user_model.dart';
import 'package:salon/ui/agendar_horario/agendar_horario_page.dart';
import 'package:salon/ui/auth_or_home.dart';
import 'package:salon/ui/edit_perfil/edit_perfil_page.dart';
import 'package:salon/ui/valores/valores_page.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black87,
    statusBarColor: markPrimaryColor,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark 
  ));
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
      ],
      locale: const Locale('pt'),
      debugShowCheckedModeBanner: false,
      title: 'Salon',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: markPrimaryColor,
          centerTitle: true,
          elevation: 0
        ),
        textTheme: GoogleFonts.assistantTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      initialRoute: AppRoutes.AUTH_OR_HOME,
      routes: {
        AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
        AppRoutes.AGENDAR_HORARIO: (ctx) => AgendarHorarioPage(),
        AppRoutes.EDITAR_PERFIL: (ctx) => EditPerfilPage(ModalRoute.of(ctx)!.settings.arguments as UserModel),
        AppRoutes.VALORES: (ctx) => ValoresPage(),
      }
    );
  }
}