import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/procedimento_model.dart';
import 'package:salon/providers/procedimentos.dart';
import 'package:salon/ui/_common/primary_button.dart';
import 'package:salon/ui/auth/components/input_text_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ProcedimentoDetailsManagerPage extends StatefulWidget {
  final ProcedimentoModel? procedimento;

  ProcedimentoDetailsManagerPage(this.procedimento);

  @override
  _ProcedimentoDetailsManagerPageState createState() => _ProcedimentoDetailsManagerPageState();
}

class _ProcedimentoDetailsManagerPageState extends State<ProcedimentoDetailsManagerPage> {
  bool isLoading = false;

  final FocusNode _procedimentoFocus = new FocusNode();
  final FocusNode _priceFocus = new FocusNode();

  TextEditingController _procedimentoController = TextEditingController();
  TextEditingController? _priceController;

  Color? pickerColor;

  late DateTime time;
  final formatter = DateFormat('HH:mm');

  Future<void> _showDialogColors() async{
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
        actionsPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        title: const Text('Selecione uma cor', textAlign: TextAlign.center, style: TextStyle(color: markPrimaryColor, fontWeight: FontWeight.bold),),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor == null ? Colors.green : pickerColor!,
            onColorChanged: changeColor,
            showLabel: false,
            pickerAreaHeightPercent: 0.8,
            pickerAreaBorderRadius: BorderRadius.circular(20),
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            child: PrimaryButton('OK', ()=> Navigator.pop(context)))
        ],
      )
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> _finish() async {

    if(_procedimentoController.text ==''){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Informe o procedimento', textAlign: TextAlign.center), backgroundColor: Colors.red[700],));

      return;
    }

    if(pickerColor == null){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecione a cor', textAlign: TextAlign.center), backgroundColor: Colors.red[700],));

      return;
    }  

    setState(()=> isLoading = true);
    
    if(widget.procedimento == null){
      ProcedimentoModel p = ProcedimentoModel('', _procedimentoController.text, _priceController!.text, pickerColor!, time);
      await Provider.of<Procedimentos>(context, listen: false).addProcedimento(p);
    } else{ 
      ProcedimentoModel p = ProcedimentoModel(widget.procedimento!.id, _procedimentoController.text, _priceController!.text, pickerColor!, time);
      await Provider.of<Procedimentos>(context, listen: false).editProcedimento(p);
    }

    Navigator.pop(context);
  }

  Future<void> _close() async {
    setState(()=> isLoading = true);
    
    if(widget.procedimento !=null)
    await Provider.of<Procedimentos>(context, listen: false).deleteProcedimento(widget.procedimento!.id);

    Navigator.pop(context);
  } 

  @override
  void initState() {
    super.initState();
    _procedimentoFocus.addListener(() { setState(() {});});
    _priceFocus.addListener(() { setState(() {});});

    _procedimentoController.text = widget.procedimento == null ? '' : widget.procedimento!.type;
    _priceController = MoneyMaskedTextController(initialValue: widget.procedimento == null ? 0 : double.parse(widget.procedimento!.price.replaceAll(',', '.')));
    pickerColor = widget.procedimento == null ? null : widget.procedimento!.color;
    time = widget.procedimento == null ? DateTime(2021, 1, 1, 0, 30) : widget.procedimento!.time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.procedimento == null? 'Criar Procedimento' :'Editar Procedimento'),),
      body: isLoading
      ? Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
      : Container(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          children: [
            InputTextWidget(
              color: markPrimaryColor,
              controller: _procedimentoController,
              label: 'Procedimento', 
              icon: Icons.star, 
              focus: _procedimentoFocus, 
              keyboarType: TextInputType.text,
            ),
            SizedBox(height: 20,),
            InputTextWidget(
              color: markPrimaryColor,
              controller: _priceController,
              label: 'Valor', 
              icon: Icons.attach_money, 
              focus: _priceFocus, 
              keyboarType: TextInputType.number,
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: _showDialogColors,
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: markPrimaryColor, width: 2),
                  borderRadius: BorderRadius.circular(25),
                  color: pickerColor == null ? Theme.of(context).scaffoldBackgroundColor : pickerColor
                ),
                child: Center(child: Text(pickerColor == null ? 'Selecione uma cor' : '', style: TextStyle(fontSize: 16),)),
              ),
            ),
            SizedBox(height: 20,),
            Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: markPrimaryColor, width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        setState(() => time = time.subtract(Duration(minutes: 15)));
                      }, 
                      icon: Icon(Icons.remove, color: markPrimaryColor)
                    ),
                    Text(
                      '${formatter.format(time)} h',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: (){
                        setState(() => time = time.add(Duration(minutes: 15)));
                      }, 
                      icon: Icon(Icons.add, color: markPrimaryColor)
                    ),
                  ],
                ),
              ),
            Spacer(),
            Row(
              children: [
                Expanded(child: PrimaryButton(
                  widget.procedimento != null ? 'EXCLU??R' : 'CANCELAR',
                  _close
                )),
                SizedBox(width: 20,),
                Expanded(child: PrimaryButton('SALVAR', _finish)),
              ],
            )
          ],
        ),
      ),
    );
  }
}