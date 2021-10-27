import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/horario_model.dart';
import 'package:salon/models/type_model.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/providers/horarios.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/agendar_horario/components/input_text_agendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({ Key? key }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final List<TypeModel> types = [
    TypeModel('Corte Feminino', Colors.pink),
    TypeModel('Corte Masculino', Colors.blue),
    TypeModel('Unhas', Colors.amber),
  ];  
  TextEditingController _nameControler = TextEditingController();

  String userId='';

  bool isLoading = false;
  bool isSaving = false;
  int index = -1;

  _showModal(CalendarTapDetails details) {
    if(details.appointments == null) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context, 
        builder: (context) {
          return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Agendamento de Horário', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  InputTextAgendar(label: 'Nome', controller: _nameControler),
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
                  if(isSaving)
                  CircularProgressIndicator(color: markPrimaryColor,)
                  else
                  Row(
                    children: [
                      Expanded(child: PrimaryButton('SALVAR', () async {
                         setState(() => isSaving = true);
                        await _onSave(details);
                         setState(() => isSaving = false);
                      })),
                    ],
                  ),
                ],
              ),
            );
          });
        }
      );
    } else {
      if(details.appointments!.first.userId == Provider.of<Auth>(context, listen: false).user!.id){
        var a = types.firstWhere((element) => element.label == details.appointments!.first.type);
        index = types.indexOf(a);
        showModalBottomSheet(
        isScrollControlled: true,
        context: context, 
        builder: (context) {
          return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Editar Horário', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  InputTextAgendar(label: 'Nome', controller: _nameControler),
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
                  if(isSaving)
                  CircularProgressIndicator(color: markPrimaryColor,)
                  else
                  Row(
                    children: [
                      Expanded(child: PrimaryButton('EXCLUÍR', () async {
                         setState(() => isSaving = true);
                        await _onDelete(details);
                         setState(() => isSaving = false);
                      })),
                      SizedBox(width: 30,),
                      Expanded(child: PrimaryButton('SALVAR', () async {
                         setState(() => isSaving = true);
                        await _onEdit(details);
                         setState(() => isSaving = false);
                      })),
                    ],
                  ),
                ],
              ),
            );
          });
        }
      );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Horário Indisponível', textAlign: TextAlign.center,), backgroundColor: Colors.red[700],)
        );  
      }
    }
  }

  Future<void> _onEdit(CalendarTapDetails details) async {
  
    await Provider.of<Horarios>(context, listen: false).editHorario(details.appointments!.first.id, _nameControler.text, types[index]);

    index = -1;

    Navigator.pop(context);
  }

  Future<void> _onDelete(CalendarTapDetails details) async {
    
    await Provider.of<Horarios>(context, listen: false).deleteHorario(details.appointments!.first.id);

    index = -1;

    Navigator.pop(context);
  }

  Future<void> _onSave(CalendarTapDetails details) async {

    final user = Provider.of<Auth>(context, listen: false).user;
    var time = DateTime(2021, details.date!.month, details.date!.day, details.date!.hour, details.date!.minute , 0 );
    HorarioModel h = HorarioModel(
      id: '',
      name: _nameControler.text, 
      start: time, 
      end:  time.add(const Duration(minutes: 30)), 
      background: types[index].color, 
      type: types[index].label,
      userId: user!.id 
    );

    await Provider.of<Horarios>(context, listen: false).addHorario(h);
    
    index = -1;

    Navigator.pop(context);
  }

  Future<void> _loadHorarios() async {
    setState(() => isLoading = true);
    await Provider.of<Horarios>(context, listen: false).loadHorarios();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _loadHorarios());
    final user = Provider.of<Auth>(context, listen: false).user;
    _nameControler.text = user!.name;
    userId = user.id;
  }

  @override
  Widget build(BuildContext context) {
    final h = Provider.of<Horarios>(context).horarios;
    
    return isLoading
    ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
    : SfCalendar(
      minDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().minute < 30 ? DateTime.now().hour : DateTime.now().hour + 1,
        DateTime.now().minute < 30 ? 30 : 0,
      ),
      onTap: _showModal,
      firstDayOfWeek: 1,
      appointmentBuilder: (context, details) {
        final HorarioModel h = details.appointments.first;
        return Container(
          color: h.userId ==  userId ? h.background : Colors.black54,
          child: ListTile(
            title: Text(
              h.userId ==  userId ? h.name.toUpperCase() : 'Indisponível', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              h.userId ==  userId ? h.type : '', 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        );
      },
      view: CalendarView.day,
      todayHighlightColor: markPrimaryColor,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: markSecondaryColor, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        shape: BoxShape.rectangle,
      ),
      timeSlotViewSettings: TimeSlotViewSettings(
        timeIntervalHeight: 70,
        timeInterval: Duration(minutes: 30), 
        timeFormat: 'HH:mm'
      ),
      dataSource: MeetingDataSource(h),
      headerStyle: CalendarHeaderStyle(
        textAlign: TextAlign.center,
        backgroundColor: markSecondaryColor,
        textStyle: TextStyle(
          fontSize: 25,
          fontStyle: FontStyle.normal,
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<HorarioModel> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].start;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].end;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
