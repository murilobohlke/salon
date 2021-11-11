import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_manager/ui_manager/procedimentos_manager/components/procedimento_tile.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/_utils/app_routes.dart';
import 'package:salon/providers/procedimentos.dart';
import 'package:salon/ui/_common/primary_button.dart';

class ProcedimentosManagerPage extends StatefulWidget {
  const ProcedimentosManagerPage({ Key? key }) : super(key: key);

  @override
  _ProcedimentosManagerPageState createState() => _ProcedimentosManagerPageState();
}

class _ProcedimentosManagerPageState extends State<ProcedimentosManagerPage> {
  bool isLoading = false;

  Future<void> _loadProcedimentos() async {
    setState(() => isLoading = true);
    await Provider.of<Procedimentos>(context, listen: false).loadProcedimentos();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadProcedimentos();
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<Procedimentos>(context).procedimentos;
    
    return Scaffold(
      appBar: AppBar(title: Text('Procedimentos'),),
      body: isLoading
      ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
      : Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: p.length,
              itemBuilder: (context, index) => ProcedimentoTile(p[index]),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(child: PrimaryButton('CRIAR NOVO', ()=> Navigator.pushNamed(context, AppRoutes.PROCEDIMENTO_DETAILS_MANAGER, arguments: null))),
              ],
            )
          ],
        )
      ),
    );
  }
}