import 'package:flutter/material.dart';
import '../components/appbar/appbar.dart';
import '../components/tabuleiro_widget.dart';
import '../models/tabuleiro.dart';
import '../models/campo.dart';
import '../models/explosao_exception.dart';

class CampoMinadoApp extends StatefulWidget {
  int qtdeColunas = 0;
  int qtdeBombas = 0;

  CampoMinadoApp(List<int>data){
    this.qtdeColunas = data[0];
    this.qtdeBombas = data[1];
  }

  @override
  _CampoMinadoAppState createState() => _CampoMinadoAppState(qtdeColunas, qtdeBombas);
}
class _CampoMinadoAppState extends State<CampoMinadoApp>{
  final int qtdeColunas;
  final int qtdeBombas;
  Tabuleiro? _tabuleiro;
  bool? _venceu;
  

  _CampoMinadoAppState(this.qtdeColunas, this.qtdeBombas);

  _reiniciar(){
    setState(() {
      _venceu = false;
      _tabuleiro!.reiniciar();
      print('reiniciando...');
    });
  }

  Tabuleiro _getTabuleiro(double largura, double altura){
    
      double tamanhoCampo = largura / qtdeColunas;
      int qtdeLinhas = (altura / tamanhoCampo).floor();
      _tabuleiro = Tabuleiro (
        linhas: qtdeLinhas,
        colunas: qtdeColunas,
        qtdeBombas: qtdeBombas,
      );
      
      return _tabuleiro!;
  
  }

  void _goBack(){
    Navigator.pop(context);
    print('back');
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBar(
            won: _venceu!,
            onReiniciar: _reiniciar,
            goBack: _goBack,

        ),
        body: Container(
          color: Colors.grey,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return TabuleiroWidget(
                tabuleiro: _getTabuleiro(constraints.maxWidth, constraints.maxWidth),
                onAbrir: _abrir,
                onAlternarMarcacao: _alternarMarcacao,
              );
            },
          ),
        ),
      )
    );
  }

  void _alternarMarcacao(Campo campo ) {
    if(_venceu != null){
      return;
    }
    setState(() {
      campo.alternarMarcacao();
      if(_tabuleiro!.resolvido){
        _venceu = true;
      }
    });
  }

  void _abrir(Campo campo) {
    if(_venceu != null){
      return;
    }
    setState((){

      try{
        campo.abrir();
        int l = campo.linha;
        int c = campo.coluna;

        if(_tabuleiro!.resolvido){
          _venceu = true;
        }
      } on ExplosaoException{
          _tabuleiro!.revelarBombas();
      }
    });
  }


}