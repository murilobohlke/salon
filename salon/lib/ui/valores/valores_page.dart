import 'package:flutter/material.dart';
import 'package:salon/ui/valores/components/row_info.dart';

class ValoresPage extends StatelessWidget {
  const ValoresPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Valores'),),
      body: Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          children: [
            RowInfo('Corte Feminino', '20,00'),
            RowInfo('Corte Masculino', '15,00'),
            RowInfo('Unhas', '10,00'),
          ],
        )
      ),
    );
  }
}