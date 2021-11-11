import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/providers/auth.dart';
import 'package:salon/providers/horarios.dart';
import 'package:salon/ui/_common/header.dart';
import 'package:salon/ui/historic/historic_tile.dart';

class HistoricPage extends StatefulWidget {
  const HistoricPage({ Key? key }) : super(key: key);

  @override
  _HistoricPageState createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  bool isLoading = false;

  Future<void> _loadHorarios() async {
    setState(()=>isLoading = true);
    await Provider.of<Horarios>(context, listen: false).loadHorarios();
    setState(()=>isLoading = false);
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _loadHorarios());
  }
  @override
  Widget build(BuildContext context) {
    String id = Provider.of<Auth>(context, listen: false).user!.id;
    final h = Provider.of<Horarios>(context,).historicoId(id);

    return isLoading
    ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),) 
    : AnimatedCard(
      direction: AnimatedCardDirection.left,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header('Meu Histórico'),
              SizedBox(height: 30,),
              h.length == 0 
              ? Expanded(child: Center(child: Text('Sem histórico', style: TextStyle(fontSize: 16),)))
              : ListView.builder(
                shrinkWrap: true,
                itemCount: h.length,
                itemBuilder: (context, index) => HistoricTile(h[index])
              )
            ]
          )
      ),
    );
  }
}