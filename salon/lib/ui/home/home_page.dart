import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/_utils/app_routes.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/ui/home/components/card_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  static String getSaudacaoText({required String nome}) {
    DateTime now = DateTime.now();
    if (nome != "") {
      if (now.hour < 12 && now.hour >= 6) return "Bom dia, $nome";
      if (now.hour >= 12 && now.hour <= 18) return "Boa tarde, $nome";
      if (now.hour >= 19 || now.hour < 6) return "Boa noite, $nome";
    }
    return "Bem vindo";
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user;
    return Scaffold(
      appBar: AppBar(),
      body: AnimatedCard(
        direction: AnimatedCardDirection.bottom,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Text(
                'Salon', 
                textAlign: TextAlign.center, 
                style: GoogleFonts.dancingScript(
                  fontSize: 60, 
                  color: Colors.red[700], 
                  fontWeight: FontWeight.bold
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color:Colors.red[700]),
                  SizedBox(width: 10,),
                  Text(
                    '(53) 98418-3079',
                    style: TextStyle(fontSize: 20, color: Colors.red[700], fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Text(
                getSaudacaoText(nome: user?.name ?? '' ),
                style: TextStyle(fontSize: 18, color: markPrimaryColor, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              CardButton(
                'AGENDAR HOR??RIO', 
                Icons.calendar_today,
                () => Navigator.pushNamed(context, AppRoutes.AGENDAR_HORARIO)
              ),
              SizedBox(height: 30,),
              CardButton(
                'CONSULTAR VALORES', 
                Icons.attach_money,
                () => Navigator.pushNamed(context, AppRoutes.VALORES)
              ),
              Spacer()
            ],
          ),
        ),
      )
    );
  }
}