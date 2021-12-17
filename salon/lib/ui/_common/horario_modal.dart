import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/horario_model.dart';
import 'package:salon/models/procedimento_model.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/providers/horarios.dart';
import 'package:salon/providers/procedimentos.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/agendar_horario/components/input_text_agendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HorarioModal extends StatefulWidget {
  final CalendarTapDetails details;

  const HorarioModal(this.details);

  @override
  _HorarioModalState createState() => _HorarioModalState();
}

class _HorarioModalState extends State<HorarioModal> {
  final TextEditingController _nameController = TextEditingController();
  
  bool isSaving = false;
  int index = -1;
  String error = '';

  late List<ProcedimentoModel> types;
  late String userId;

  bool isPossible(DateTime start, DateTime end){
    bool resp = true;
    final h = Provider.of<Horarios>(context, listen: false).horarios.where(
      (element) => (element.start.day == start.day && element.start.month == start.month && element.start.year == start.year )
    );

    h.forEach((element) {
      if(start.isBefore(element.start) && end.isAfter(element.start)){
        resp = false;
      } 
      
    });
    
    return resp;
  }

  Future<void> _onEdit(CalendarTapDetails details) async {
    var start = DateTime(2021, details.date!.month, details.date!.day, details.date!.hour, details.date!.minute, 0 );
    var end = start.add(Duration(hours: types[index].time.hour, minutes: types[index].time.minute));

    if(!isPossible(start,end)){
      setState(() => error = 'Tempo insuficiente');
      return;
    }

    HorarioModel h = HorarioModel(
      id: details.appointments!.first.id,
      name: _nameController.text, 
      start: start, 
      end:  end, 
      background: types[index].color, 
      type: types[index].type,
      userId: userId
    );

    await Provider.of<Horarios>(context, listen: false).editHorario(h);
    index = -1;
    Navigator.pop(context);
  }

  Future<void> _onDelete(CalendarTapDetails details) async {
    await Provider.of<Horarios>(context, listen: false).deleteHorario(details.appointments!.first.id);
    index = -1;
    Navigator.pop(context);
  }

  Future<void> _onSave(CalendarTapDetails details) async {
    if(index == -1){
      setState(() => error = 'Por favor, selecione o tipo');
      return;
    }

    var start = DateTime(2021, details.date!.month, details.date!.day, details.date!.hour, details.date!.minute, 0 );
    var end = start.add(Duration(hours: types[index].time.hour, minutes: types[index].time.minute));

    if(!isPossible(start,end)){
      setState(() => error = 'Tempo insuficiente');
      return;
    }

    HorarioModel h = HorarioModel(
      id: '',
      name: _nameController.text, 
      start: start, 
      end:  end, 
      background: types[index].color, 
      type: types[index].type,
      userId: userId
    );

    await Provider.of<Horarios>(context, listen: false).addHorario(h);
    index = -1;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    final user = Provider.of<Auth>(context, listen: false).user;

    widget.details.appointments == null ? _nameController.text = user!.name : _nameController.text = widget.details.appointments!.first.name;
    userId = user!.id;
    types = Provider.of<Procedimentos>(context, listen: false).procedimentos;
    
    if(widget.details.appointments != null){
      var p = types.firstWhere((element) => element.type == widget.details.appointments!.first.type);
      index = types.indexOf(p);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.details.appointments == null ? 'Agendamento de Horário' :'Editar Horário', 
            textAlign: TextAlign.center, 
            style: TextStyle(color: markPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20,),
          InputTextAgendar(label: 'Nome', controller: _nameController),
          SizedBox(height: 10,),
          Text('Selecione o Tipo', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 16,),),
          ListView.builder(
            shrinkWrap: true,
            itemCount: types.length,
            itemBuilder: (context, i) => Container(
              height: 35,
              child: RadioListTile(
                activeColor: markPrimaryColor,
                title: Text(types[i].type),
                value: i, 
                groupValue: index, 
                onChanged: (value) {
                  error = '';
                  index = value as int;
                  setState((){});
                }
              ),
            ),
          ),
          SizedBox(height: 20,),
          if(isSaving)
          CircularProgressIndicator(color: markPrimaryColor,)
          else
          Row(
            children: [
              if(widget.details.appointments != null)
              Expanded(
                child: PrimaryButton(
                  'EXCLUÍR', 
                  () async {
                    setState(() => isSaving = true);
                    await _onDelete(widget.details);
                    setState(() => isSaving = false);
                  }
                )
              ),
              if(widget.details.appointments != null)
              SizedBox(width: 30,),
              Expanded(
                child: PrimaryButton(
                  'SALVAR', 
                  () async {
                    setState(() => isSaving = true);
                    widget.details.appointments == null ? await _onSave(widget.details) : await _onEdit(widget.details);
                    setState(() => isSaving = false);
                  }
                )
              ),
            ],
          ),
          Text(error, style: TextStyle(fontSize: 16, color: Colors.red[700], fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}