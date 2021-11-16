import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/providers/clientes.dart';
import 'package:salon/ui/_common/header.dart';
import 'package:salon/ui/ui_manager/clientes_manager/components/cliente_tile.dart';

class ClientesmanagerPage extends StatefulWidget {
  const ClientesmanagerPage({ Key? key }) : super(key: key);

  @override
  _ClientesmanagerPageState createState() => _ClientesmanagerPageState();
}

class _ClientesmanagerPageState extends State<ClientesmanagerPage> {
  bool isLoading = false;

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await Provider.of<Clientes>(context, listen: false).loadClientes();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    final clientes = Provider.of<Clientes>(context).clientes;

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
              Header('Meus Clientes'),
              SizedBox(height: 30,),
              Text('Total de Clientes: ${clientes.length}', style: TextStyle(fontSize: 18),),
              SizedBox(height: 20,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: clientes.length,
                itemBuilder: (context, index) => ClienteTile(clientes[index])
              )
            ]
          )
      ),
    );
  }
}