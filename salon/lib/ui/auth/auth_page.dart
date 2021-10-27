import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/exceptions/auth_exception.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/auth/components/input_text_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({ Key? key }) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FocusNode _emailFocus = new FocusNode();
  final FocusNode _passwordFocus = new FocusNode();
  final FocusNode _confirmPasswordFocus = new FocusNode();
  final FocusNode _nameFocus = new FocusNode();
  final FocusNode _phoneFocus = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = MaskedTextController(mask: '(00) 00000-0000');

  bool isLogin = true;
  bool isLoading = false;

  File? _storedImage;

  Future<void> _image () async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 50, 
      maxHeight: 480, 
      maxWidth: 640, 
    );
    _storedImage = File(photo!.path);
    setState(() {});
  }

  void _changeMode () {
    _storedImage = null;
    _emailController.text = '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
    _nameController.text = '';
    _phoneController.text = '';
    setState(() => isLogin = !isLogin);
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text, textAlign: TextAlign.center), backgroundColor: Colors.red[700],)
    );
  }

  void _login() async{

    if(_emailController.text==''){
      _showSnackBar('Informe um email válido');
      return;
    }

    if(_passwordController.text==''){
      _showSnackBar('Informe uma senha válida');
      return;
    }
    
    setState(() => isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).login(_emailController.text.trim(), _passwordController.text);
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString(), textAlign: TextAlign.center,), backgroundColor: Colors.red[700],)
      );
    }catch (e) {
      print(e);
    }
  }

  void _signUp() async{

    if(_storedImage == null){ _showSnackBar('Selecione uma imagem'); return;}
    if(_nameController.text==''){ _showSnackBar('Nome não pode ser vazio'); return;}
    if(_phoneController.text==''){ _showSnackBar('Telefone não pode ser vazio'); return;}
    if(_emailController.text==''){ _showSnackBar('Email não pode ser vazio'); return;}
    if(_passwordController.text==''){_showSnackBar('Senha não pode ser vazio'); return;}
    if(_passwordController.text.length<6){_showSnackBar('Senha deve conter pelo menos 6 caracteres'); return;}
    if(_passwordController.text != _confirmPasswordController.text){_showSnackBar('As senhas não conferem'); return;}

    setState(() => isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).signUp(
        _emailController.text.trim(),
         _passwordController.text, 
         _nameController.text, 
         _phoneController.text,
         _storedImage!.path
      );
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString(), textAlign: TextAlign.center,), backgroundColor: Colors.red[700],)
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() { setState(() {});});
    _phoneFocus.addListener(() { setState(() {});});
    _emailFocus.addListener(() { setState(() {});});
    _passwordFocus.addListener(() { setState(() {});});
    _confirmPasswordFocus.addListener(() { setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: markSecondaryColor,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            height: isLogin ? 315 : 630,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: isLoading 
            ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
            : SingleChildScrollView(
                child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Salon', textAlign: TextAlign.center, style: GoogleFonts.dancingScript(fontSize: 35, color: Colors.red[700], fontWeight: FontWeight.w800),),
                    if(!isLogin)
                    SizedBox(height: 20,),
                    if(!isLogin)
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
                            child: _storedImage == null 
                            ? Text('Adicionar Foto', style: TextStyle(color: Colors.black),)
                            : ClipRRect(
                              borderRadius:BorderRadius.all(Radius.circular(120)) ,
                              child: Image.file(File(_storedImage!.path), height: 120, width: 120, fit: BoxFit.cover,)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right:100,
                          child: IconButton(onPressed: _image, icon: Icon(Icons.camera_alt, color: Colors.white))
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    if(!isLogin)
                    InputTextWidget(
                      key: ValueKey('name'),
                      controller: _nameController,
                      label: 'Nome', 
                      icon: Icons.person,
                      keyboarType: TextInputType.name, 
                      focus: _nameFocus,
                    ),
                    if(!isLogin)
                    SizedBox(height: 10,),
                    if(!isLogin)
                    InputTextWidget(
                      key: ValueKey('phone'),
                      controller: _phoneController,
                      label: 'Telefone', 
                      icon: Icons.phone,
                      keyboarType: TextInputType.phone, 
                      focus: _phoneFocus,
                    ),
                    if(!isLogin)
                    SizedBox(height: 10,),
                    InputTextWidget(
                      color: markPrimaryColor,
                      key: ValueKey('email'),
                      controller: _emailController,
                      label: 'Email', 
                      icon: Icons.mail, 
                      focus: _emailFocus, 
                      keyboarType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10,),
                    InputTextWidget(
                      color: markPrimaryColor,
                      key: ValueKey('password'),
                      controller: _passwordController,
                      obscureText: true,
                      label: 'Senha', 
                      icon: Icons.lock,
                      keyboarType: TextInputType.number,
                      focus: _passwordFocus,
                    ),
                    if(!isLogin)
                    SizedBox(height: 10,),
                    if(!isLogin)
                    InputTextWidget(
                      controller: _confirmPasswordController,
                      key: ValueKey('confirmPassword'),
                      obscureText: true,
                      label: 'Confirmar Senha', 
                      icon: Icons.lock,
                      keyboarType: TextInputType.number, 
                      focus: _confirmPasswordFocus,
                    ),
                    SizedBox(height: 30,),
                    PrimaryButton(isLogin ? 'LOGIN' : 'CRIAR', (){
                      if (_formKey.currentState!.validate()) {
                        isLogin ? _login() : _signUp();    
                      }
                    }),
                    TextButton(
                      onPressed: _changeMode, 
                      child: Text(isLogin ? 'Criar nova conta?' : 'Já tenho conta!', style: TextStyle(color: markTertiaryColor, fontSize: 15, fontWeight: FontWeight.bold),)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}