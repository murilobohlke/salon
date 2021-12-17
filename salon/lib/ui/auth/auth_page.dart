import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/exceptions/auth_exception.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/ui/auth/components/form_login.dart';
import 'package:salon/ui/auth/components/form_new_user.dart';

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
    FocusScope.of(context).unfocus();
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
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            height: isLogin ? 330 : 640,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: isLoading 
            ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
            : isLogin
            ? FormLogin(
              emailController: _emailController, 
              emailFocus: _emailFocus, 
              passwordController: _passwordController, 
              passwordFocus: _passwordFocus, 
              login: _login, 
              changeMode: _changeMode)
            : FormNewUser(
              pathImage: _storedImage?.path ?? null,
              image: _image,
              changeMode: _changeMode,
              signUp: _signUp,
              emailController: _emailController, 
              emailFocus: _emailFocus, 
              passwordController: _passwordController, 
              passwordFocus: _passwordFocus,
              nameController: _nameController,
              nameFocus: _nameFocus,
              confirmPasswordController: _confirmPasswordController,
              confirmPasswordFocus: _confirmPasswordFocus,
              phoneController: _phoneController,
              phoneFocus:_phoneFocus,
            )
          ),
        ),
      ),
    );
  }
}