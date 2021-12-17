import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/_utils/app_routes.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/ui/_common/header.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/perfil/components/row_info.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user;
    
    return AnimatedCard(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header('Meu Perfil'),
              Spacer(),
              ClipRRect(
                borderRadius:BorderRadius.all(Radius.circular(100)),
                child: Image.network(
                  user!.image, 
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ), 
              ),
              SizedBox(height: 30,),
              RowInfo(user.name, Icons.person, FontWeight.bold),
              RowInfo(user.email, Icons.mail),
              RowInfo(user.phone, Icons.phone),
              SizedBox(height: 60,),
              Row(
                children: [
                  Expanded(child: PrimaryButton('EDITAR', ()=> Navigator.pushNamed(context, AppRoutes.EDITAR_PERFIL, arguments: user))),
                  SizedBox(width: 30,),
                  Expanded(child: PrimaryButton('SAIR', ()=> Provider.of<Auth>(context, listen: false).logout() )),
                ],
              ),
              Spacer()
            ]
          )
      ),
    );
  }
}