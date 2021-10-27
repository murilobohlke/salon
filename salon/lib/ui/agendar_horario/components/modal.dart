import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/type_model.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/agendar_horario/components/input_text_agendar.dart';

class Modal extends StatefulWidget {
  final TextEditingController controller;
  final int index;
  final bool isSaving;
  final Function onSave;
  const Modal(this.controller, this.index, this.isSaving, this.onSave);

  @override
  _ModalState createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  int index = -1;

  final List<TypeModel> types = [
    TypeModel('Corte Feminino', Colors.pink),
    TypeModel('Corte Masculino', Colors.blue),
    TypeModel('Unhas', Colors.amber),
  ];  

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Agendamento de Horário', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          InputTextAgendar(label: 'Nome', controller: widget.controller),
          SizedBox(height: 10,),
          Text('Selecione o Tipo', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 16,),),
          ListView.builder(
            shrinkWrap: true,
            itemCount: types.length,
            itemBuilder: (context, i) => Container(
              height: 35,
              child: RadioListTile(
                activeColor: markPrimaryColor,
                title: Text(types[i].label),
                value: i, 
                groupValue: index, 
                onChanged: (value)=> setState(() => index = value as int)
              ),
            ),
          ),
          SizedBox(height: 20,),
          if(widget.isSaving)
          CircularProgressIndicator(color: markPrimaryColor,)
          else
          Row(
            children: [
              Expanded(child: PrimaryButton('SALVAR', ()=> widget.onSave)),
            ],
          ),
        ],
      ),
    );
  }
}