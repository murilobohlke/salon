import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/ui/_common/primary_button.dart';

import 'input_text_widget.dart';

class FormNewUser extends StatefulWidget {
  final VoidCallback signUp;
  final VoidCallback changeMode;
  final VoidCallback image;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController confirmPasswordController;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode phoneFocus;
  final FocusNode confirmPasswordFocus;
  final String? pathImage;
  
  const FormNewUser({
    required this.emailController,
    required this.emailFocus,
    required this.passwordController,
    required this.nameController,
    required this.phoneController,
    required this.confirmPasswordController,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.phoneFocus,
    required this.nameFocus,
    required this.changeMode, 
    required this.signUp,
    required this.image, 
    required this.pathImage, 
  });

  @override
  _FormNewUserState createState() => _FormNewUserState();
}

class _FormNewUserState extends State<FormNewUser> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Salon', textAlign: TextAlign.center, style: GoogleFonts.dancingScript(fontSize: 35, color: Colors.red[700], fontWeight: FontWeight.w800),),
            SizedBox(height: 20,),
            Stack(
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: markSecondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(60))
                    ),
                    height: 120,
                    width: 120,
                    child: widget.pathImage == null 
                    ? Text('Adicionar Foto', style: TextStyle(color: Colors.black),)
                    : ClipRRect(
                      borderRadius:BorderRadius.all(Radius.circular(120)) ,
                      child: Image.file(File(widget.pathImage!), height: 120, width: 120, fit: BoxFit.cover,)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  left: 10,
                  child: IconButton(onPressed: widget.image, icon: Icon(Icons.camera_alt, color: Colors.white))
                )
              ],
            ),
            SizedBox(height: 20,),
            InputTextWidget(
              key: ValueKey('name'),
              controller: widget.nameController,
              label: 'Nome', 
              icon: Icons.person,
              keyboarType: TextInputType.name, 
              focus: widget.nameFocus,
            ),
            SizedBox(height: 10,),
            InputTextWidget(
              key: ValueKey('phone'),
              controller: widget.phoneController,
              label: 'Telefone', 
              icon: Icons.phone,
              keyboarType: TextInputType.phone, 
              focus: widget.phoneFocus,
            ),
            SizedBox(height: 10,),
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
            SizedBox(height: 10,),
            InputTextWidget(
              controller: widget.confirmPasswordController,
              key: ValueKey('confirmPassword'),
              obscureText: true,
              label: 'Confirmar Senha', 
              icon: Icons.lock,
              keyboarType: TextInputType.number, 
              focus: widget.confirmPasswordFocus,
            ),
            SizedBox(height: 30,),
            PrimaryButton(
              'CRIAR', 
              widget.signUp
            ),
            TextButton(
              onPressed: widget.changeMode, 
              child: Text('Já tenho conta!', style: TextStyle(color: markTertiaryColor, fontSize: 15, fontWeight: FontWeight.bold),)
            ),
          ],
        ),
      ),
    );
  }
}