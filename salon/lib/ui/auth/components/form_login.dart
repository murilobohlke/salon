import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/auth/components/input_text_widget.dart';

class FormLogin extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final VoidCallback login;
  final VoidCallback changeMode;

  FormLogin({
    required this.emailController,
    required this.emailFocus,
    required this.passwordController,
    required this.passwordFocus,
    required this.login,
    required this.changeMode
  });

  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Salon', textAlign: TextAlign.center, style: GoogleFonts.dancingScript(fontSize: 35, color: Colors.red[700], fontWeight: FontWeight.w800),),
          SizedBox(height: 20,),
          InputTextWidget(
            color: markPrimaryColor,
            key: ValueKey('email'),
            controller: widget.emailController,
            label: 'Email', 
            icon: Icons.mail, 
            focus: widget.emailFocus, 
            keyboarType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10,),
          InputTextWidget(
            color: markPrimaryColor,
            key: ValueKey('password'),
            controller: widget.passwordController,
            obscureText: true,
            label: 'Senha', 
            icon: Icons.lock,
            keyboarType: TextInputType.number,
            focus: widget.passwordFocus,
          ),
          SizedBox(height: 30,),
          PrimaryButton(
            'LOGIN', 
            widget.login
          ),
          TextButton(
            onPressed: widget.changeMode, 
            child: Text('Criar nova conta?', style: TextStyle(color: markTertiaryColor, fontSize: 15, fontWeight: FontWeight.bold),)
          ),
        ],
      ),
    );
  }
}