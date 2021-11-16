import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/_utils/horario_data_source.dart';
import 'package:salon/models/horario_model.dart';
import 'package:salon/models/procedimento_model.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/providers/horarios.dart';
import 'package:salon/providers/procedimentos.dart';
import 'package:salon/ui/_common/horario_modal.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({ Key? key }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<ProcedimentoModel> types = [];  
  TextEditingController _nameControler = TextEditingController();

  String userId='';
  String error='';

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
    if(details.appointments == null || details.appointments!.first.userId == userId && details.appointments!.first.type != ''){
      showModalBottomSheet(
        isScrollControlled: true,
        context: context, 
        builder: (_) => HorarioModal(details)
      );
    } else{
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Horário Ocupado', textAlign: TextAlign.center,), backgroundColor: Colors.red[700], )
      );
    }
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
          color: h.userId ==  userId ? h.background : Colors.black54,
          child: Center(
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
      dataSource: HorarioDataSource(h),
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
