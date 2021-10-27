
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/user_model.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/auth/components/input_text_widget.dart';

class EditPerfilPage extends StatefulWidget {
  final UserModel user;

  const EditPerfilPage(this.user);

  @override
  _EditPerfilPageState createState() => _EditPerfilPageState();
}

class _EditPerfilPageState extends State<EditPerfilPage> {
  final FocusNode _nameFocus = new FocusNode();
  final FocusNode _phoneFocus = new FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = MaskedTextController(mask: '(00) 00000-0000');
  
  bool isLoading = false;

  Future<void> _editPerfil () async{
    setState(() => isLoading = true);
    await Provider.of<Auth>(context, listen: false).editUser(widget.user.id, _nameController.text, _phoneController.text);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
     _nameFocus.addListener(() { setState(() {});});
     _phoneFocus.addListener(() { setState(() {});});

     _nameController.text = widget.user.name;
     _phoneController.text = widget.user.phone;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil'),),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: isLoading
        ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),) 
        : SingleChildScrollView(
                  child: Column(
            children: [
              SizedBox(height: 60,),
              ClipRRect(
                borderRadius:BorderRadius.all(Radius.circular(100)),
                child: Image.network(
                  widget.user.image,
                  height: 200,
                  width: 200, 
                  fit: BoxFit.cover,
                )
              ),
              SizedBox(height: 40,),
              InputTextWidget(
                color: markPrimaryColor,
                controller: _nameController,
                label: 'Nome', 
                icon: Icons.person, 
                focus: _nameFocus, 
                keyboarType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20,),
              InputTextWidget(
                color: markPrimaryColor,
                controller: _phoneController,
                label: 'Telefone', 
                icon: Icons.phone,
                keyboarType: TextInputType.phone, 
                focus: _phoneFocus,
              ),
              SizedBox(height: 60,),
              Row(
                children: [
                  Expanded(child: PrimaryButton('SALVAR', _editPerfil)),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}