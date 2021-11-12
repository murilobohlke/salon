import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/horario_model.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/providers/horarios.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class IndisponivelModal extends StatefulWidget {
  final CalendarLongPressDetails details;

  const IndisponivelModal(this.details);

  @override
  _IndisponivelModalState createState() => _IndisponivelModalState();
}

class _IndisponivelModalState extends State<IndisponivelModal> {
  final formatter = DateFormat('HH:mm');
  
  bool isSaving = false;

  late DateTime initialTime;
  late DateTime endTime;

  late String userId;

   Future<void> _onEdit(CalendarLongPressDetails details, DateTime initialTime, DateTime endTime) async {
    await Provider.of<Horarios>(context, listen: false).editHorarioManager(details.appointments!.first.id, initialTime, endTime);
    Navigator.pop(context);
  }

  Future<void> _onDelete(CalendarLongPressDetails details) async {
    await Provider.of<Horarios>(context, listen: false).deleteHorario(details.appointments!.first.id);
    Navigator.pop(context);
  }

  Future<void> _onSave(DateTime initialTime, DateTime endTime) async {
    
    final user = Provider.of<Auth>(context, listen: false).user;
    
    HorarioModel h = HorarioModel(
      id: '',
      name: 'INDISPONÍVEL', 
      start: initialTime, 
      end:  endTime, 
      background: Colors.black54, 
      type: '',
      userId: user!.id 
    );

    await Provider.of<Horarios>(context, listen: false).addHorario(h);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    userId = Provider.of<Auth>(context, listen: false).user!.id;
    
    if(widget.details.appointments != null){
      initialTime = widget.details.appointments!.first.start;
      endTime = widget.details.appointments!.first.end;
    } else{
      initialTime = DateTime(2021, widget.details.date!.month, widget.details.date!.day, widget.details.date!.hour, widget.details.date!.minute , 0 );
      endTime = initialTime.add(const Duration(minutes: 30));
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
          Text(widget.details.appointments == null ? 'Horário Indisponível' : 'Editar Horário Indisponível', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hora Inicial',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 20,),
              IconButton(
                onPressed: (){
                  setState(() => initialTime = initialTime.subtract(Duration(minutes: 30)));
                }, 
                icon: Icon(Icons.remove, color: markPrimaryColor)
              ),
              SizedBox(width: 20,),
              Text(
                '${formatter.format(initialTime)} h',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20,),
              IconButton(
                onPressed: (){
                  if(initialTime.add(Duration(minutes: 30)).isBefore(endTime))
                  setState(() => initialTime = initialTime.add(Duration(minutes: 30)));
                }, 
                icon: Icon(Icons.add, color: markPrimaryColor)
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hora Final   ',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 20,),
              IconButton(
                onPressed: (){
                  if(endTime.subtract(Duration(minutes: 30)).isAfter(initialTime))
                  setState(() => endTime = endTime.subtract(Duration(minutes: 30)));
                }, 
                icon: Icon(Icons.remove, color: markPrimaryColor)
              ),
              SizedBox(width: 20,),
              Text(
                '${formatter.format(endTime)} h',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20,),
              IconButton(
                onPressed: (){
                  setState(() => endTime = endTime.add(Duration(minutes: 30)));
                }, 
                icon: Icon(Icons.add, color: markPrimaryColor)
              ),
             
            ],
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
                    widget.details.appointments == null ? await _onSave(initialTime, endTime) : await _onEdit(widget.details, initialTime, endTime);
                    setState(() => isSaving = false);
                  }
                )
              ),
            ],
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }
}