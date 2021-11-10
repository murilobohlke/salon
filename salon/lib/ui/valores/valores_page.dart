import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/providers/procedimentos.dart';
import 'package:salon/ui/valores/components/row_info.dart';

class ValoresPage extends StatefulWidget {
  const ValoresPage({ Key? key }) : super(key: key);

  @override
  _ValoresPageState createState() => _ValoresPageState();
}

class _ValoresPageState extends State<ValoresPage> {
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
      appBar: AppBar(title: Text('Valores'),),
      body: isLoading
      ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
      : Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: ListView.builder(
          itemCount: p.length,
          itemBuilder: (context, index) => RowInfo(p[index].type, p[index].price),
        )
      ),
    );
  }
}