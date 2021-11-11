import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/horario_model.dart';
import 'package:salon/models/procedimento_model.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/providers/horarios.dart';
import 'package:salon/providers/procedimentos.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarManager extends StatefulWidget {
  const CalendarManager({ Key? key }) : super(key: key);

  @override
  _CalendarManagerState createState() => _CalendarManagerState();
}

class _CalendarManagerState extends State<CalendarManager> {
  List<ProcedimentoModel> types = [];  
  TextEditingController _nameControler = TextEditingController();

  String userId='';


  bool isLoading = false;
  bool isSaving = false;
  int index = -1;

  DateTime minDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().minute < 30 ? DateTime.now().hour : DateTime.now().hour + 1,
    DateTime.now().minute < 30 ? 30 : 0,
  );
  
  _showModal(CalendarTapDetails details) {
    var initialTime = DateTime(2021, details.date!.month, details.date!.day, details.date!.hour, details.date!.minute , 0 );
    var endTime = initialTime.add(const Duration(minutes: 30));
    final formatter = DateFormat('HH:mm');

    if(details.appointments == null) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context, 
        builder: (context) {
          return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Horário Indisponível', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Começo:   ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        formatter.format(initialTime),
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
                      SizedBox(width: 20,),
                      IconButton(
                        onPressed: (){
                          setState(() => initialTime = initialTime.subtract(Duration(minutes: 30)));
                        }, 
                        icon: Icon(Icons.remove, color: markPrimaryColor)
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Fim:   ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        formatter.format(endTime),
                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20,),
                      IconButton(
                        onPressed: (){
                          setState(() => endTime = endTime.add(Duration(minutes: 30)));
                        }, 
                        icon: Icon(Icons.add, color: markPrimaryColor)
                      ),
                      SizedBox(width: 20,),
                      IconButton(
                        onPressed: (){
                          if(endTime.subtract(Duration(minutes: 30)).isAfter(initialTime))
                          setState(() => endTime = endTime.subtract(Duration(minutes: 30)));
                        }, 
                        icon: Icon(Icons.remove, color: markPrimaryColor)
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  if(isSaving)
                  CircularProgressIndicator(color: markPrimaryColor,)
                  else
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          'SALVAR', 
                          () async {
                            setState(() => isSaving = true);
                            await _onSave(initialTime, endTime);
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
          });
        }
      );
    } else {
      if(details.appointments!.first.userId == Provider.of<Auth>(context, listen: false).user!.id){
        var initialTime = details.appointments!.first.start;
        var endTime = details.appointments!.first.end;
        
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
                  Text('Editar Horário Indisponível', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Começo:   ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        formatter.format(initialTime),
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
                      SizedBox(width: 20,),
                      IconButton(
                        onPressed: (){
                          setState(() => initialTime = initialTime.subtract(Duration(minutes: 30)));
                        }, 
                        icon: Icon(Icons.remove, color: markPrimaryColor)
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Fim:   ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        formatter.format(endTime),
                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20,),
                      IconButton(
                        onPressed: (){
                          setState(() => endTime = endTime.add(Duration(minutes: 30)));
                        }, 
                        icon: Icon(Icons.add, color: markPrimaryColor)
                      ),
                      SizedBox(width: 20,),
                      IconButton(
                        onPressed: (){
                          if(endTime.subtract(Duration(minutes: 30)).isAfter(initialTime))
                          setState(() => endTime = endTime.subtract(Duration(minutes: 30)));
                        }, 
                        icon: Icon(Icons.remove, color: markPrimaryColor)
                      )
                    ],
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
                        await _onEdit(details, initialTime, endTime);
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
          SnackBar(content: Text('Horário Marcado', textAlign: TextAlign.center,), backgroundColor: Colors.red[700],)
        );  
      }
    }
  }

  Future<void> _onEdit(CalendarTapDetails details, DateTime initialTime, DateTime endTime) async {
  
    await Provider.of<Horarios>(context, listen: false).editHorarioManager(details.appointments!.first.id, initialTime, endTime);
    index = -1;
    Navigator.pop(context);
  }

  Future<void> _onDelete(CalendarTapDetails details) async {
    
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
  
    index = -1;

    Navigator.pop(context);
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await Provider.of<Horarios>(context, listen: false).loadHorarios();
    await Provider.of<Procedimentos>(context, listen: false).loadProcedimentos();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _loadData());
    final user = Provider.of<Auth>(context, listen: false).user;
    _nameControler.text = user!.name;
    userId = user.id;
  }

  @override
  Widget build(BuildContext context) {
    final h = Provider.of<Horarios>(context).horarios;
    types = Provider.of<Procedimentos>(context).procedimentos;
    
    return isLoading
    ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
    : SfCalendar(
      minDate: minDate,
      onTap: _showModal,
      firstDayOfWeek: 1,
      appointmentBuilder: (context, details) {
        final HorarioModel h = details.appointments.first;
        return Container(
          color: h.background,
          child: Center(
            child: ListTile(
              title: Text(
                h.name.toUpperCase(), 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                h.type, 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
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
