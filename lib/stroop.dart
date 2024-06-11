import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'usuarios.dart';

void main() async {
  runApp(MyApp());
}

Inteiro contJogadas = Inteiro(0);
Inteiro contadorAcertos = Inteiro(0);
Inteiro tempoFinal = Inteiro(0);
Inteiro erros = Inteiro(0);
Inteiro errosCorCongruentes = Inteiro(0);
Inteiro errosCorNaoCongruentes = Inteiro(0);
Double pontuacao = Double(0);

class PontuacaoStroop {
  late int tempo;
  late int acertos;
  late double pontuacao;
  late int erros;
  late int errosCorCongruentes;
  late int errosCorNaoCongruentes;

  PontuacaoStroop({
    required this.tempo,
    required this.acertos,
    required this.pontuacao,
    required this.erros,
    required this.errosCorCongruentes,
    required this.errosCorNaoCongruentes,
  });

  Map<String, dynamic> toMap() {
    return {
      'tempo': tempo,
      'acertos': acertos,
      'pontuacao': pontuacao,
      'erros total': erros,
      'erros cor congruentes': errosCorCongruentes,
      'erros cor nao congruentes': errosCorNaoCongruentes,
    };
  }

  factory PontuacaoStroop.fromMap(Map<String, dynamic> map) {
    return PontuacaoStroop(
      tempo: map['tempo'],
      acertos: map['acertos'],
      pontuacao: map['pontuacao'],
      erros: map['erros total'],
      errosCorCongruentes: map['erros cor congruentes'],
      errosCorNaoCongruentes: map['erros cor nao congruentes'],
    );
  }
}

class Cor {
  String nomeCor;
  Color colors;

  Cor(this.nomeCor, this.colors);
}

class CorPintada {
  String corPintada;

  CorPintada(this.corPintada);
}

class Inteiro {
  int _valor;

  Inteiro(this._valor);

  int get valor => _valor;

  void incrementar() {
    _valor++;
  }
}

class Double {
  double _valor;

  Double(this._valor);

  double get valor => _valor;
}

class Tempo {
  String tempoAtual;

  Tempo(this.tempoAtual);
}

Tempo estadoTempo = new Tempo('');

class CorApp extends StatefulWidget {
  @override
  _CorAppState createState() => _CorAppState();
}

class _CorAppState extends State<CorApp> {
  void finalizarJogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Jogo finalizado'),
          content: Text(
              'Você Terminou o jogo! Seu tempo foi de ${_counter} segundos , você acertou ${contadorAcertos._valor} de 15 e sua pontuação foi de ${pontuacao._valor}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelecionarJogo()));
              },
              child: Text('Retornar a página anterior'),
            ),
          ],
        );
      },
    );
  }

  String geraCorEscrita() {
    Random random = Random();
    int numeroSelecionado = random.nextInt(5);
    String corSelecionada = "";

    switch (numeroSelecionado) {
      case 0:
        corSelecionada = 'Azul';
        break;
      case 1:
        corSelecionada = 'Amarelo';
        break;
      case 2:
        corSelecionada = 'Vermelho';
        break;
      case 3:
        corSelecionada = 'Preto';
        break;
      case 4:
        corSelecionada = 'Verde';
        break;
    }

    return corSelecionada;
  }

  CorPintada corPintadaAtual = new CorPintada('');

  Color geraCor() {
    Random random = Random();
    int numeroSelecionado = random.nextInt(5);
    Color colorsSelected = Colors.white;

    switch (numeroSelecionado) {
      case 0:
        colorsSelected = Colors.blue;
        corPintadaAtual.corPintada = 'Azul';
        break;
      case 1:
        colorsSelected = Colors.yellow;
        corPintadaAtual.corPintada = 'Amarelo';
        break;
      case 2:
        colorsSelected = Colors.red;
        corPintadaAtual.corPintada = 'Vermelho';
        break;
      case 3:
        colorsSelected = Colors.black;
        corPintadaAtual.corPintada = 'Preto';
        break;
      case 4:
        colorsSelected = Colors.green;
        corPintadaAtual.corPintada = 'Verde';
        break;
    }

    return colorsSelected;
  }

  Future<void> verificaEscolha(String corSelecionada) async {
    if (cor.nomeCor == corSelecionada) {
      contadorAcertos.incrementar();
      contJogadas.incrementar();
    } else {
      erros.incrementar();
      if (cor.nomeCor == corPintadaAtual.corPintada) {
        errosCorCongruentes.incrementar();
        print('Cor Congruente');
      } else {
        errosCorNaoCongruentes.incrementar();
        print('Cor não congruente');
      }

      contJogadas.incrementar();
    }

    if (contJogadas._valor == 15) {
      tempoFinal._valor = _counter;
      print("O jogo acabou!");
      print("Você acertou ${contadorAcertos._valor}");
      print("O seu tempo foi: ${tempoFinal._valor}");

      pontuacao._valor =
          (contadorAcertos._valor * 2) - (tempoFinal._valor * 0.5);

      PontuacaoStroop pontuacaoJogada = new PontuacaoStroop(
          tempo: tempoFinal._valor,
          acertos: contadorAcertos._valor,
          pontuacao: pontuacao._valor,
          erros: erros._valor,
          errosCorCongruentes: errosCorCongruentes._valor,
          errosCorNaoCongruentes: errosCorNaoCongruentes._valor);

      enviarPontuacaoStroopLevel1(usuario, pontuacaoJogada, numeroStroop);
    }
  }

  @override
  Cor cor = Cor("", Colors.white);
  void initState() {
    cor = Cor(geraCorEscrita(), geraCor());
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (contJogadas._valor < 15) {
        _incrementCounter();
      } else {
        finalizarJogo(context);
        _timer.cancel();
      }
    });
  }
  

  void _incrementCounter() {
    setState(() {
      int minutos = 0;
      _counter++;

      if(_counter == 60) {
        minutos += 1;
        _counter = 0;
      }

      if(minutos > 0) {
        estadoTempo.tempoAtual = '${minutos} minutos e ${_counter} segundos';
      } else {
        estadoTempo.tempoAtual = '${_counter} segundos';
      }

    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} minutos';
  }

  Inteiro contJogadas = Inteiro(0);
  Inteiro contadorAcertos = Inteiro(0);
  Inteiro tempoFinal = Inteiro(0);
  Inteiro erros = Inteiro(0);
  Inteiro errosCorCongruentes = Inteiro(0);
  Inteiro errosCorNaoCongruentes = Inteiro(0);
  Double pontuacao = Double(0);

  int _counter = 0;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Column(children: [
              Row(children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "BrainGames",
                  style: TextStyle(
                      color: Color.fromRGBO(33, 150, 234, 1.0),
                      fontSize: 24,
                      fontFamily: "Montserrat"),
                ),
              ]),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Container(
                    height: 1,
                    width: 160,
                    color: Color.fromRGBO(33, 150, 234, 1.0),
                  ),
                ],
              ),
            ]),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, 
              children: [
                SizedBox(height: 20), 
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      "Stroop",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Container(
                    height: 1,
                    width: 160,
                    color: Colors.black,
                  ),
                ]),
                SizedBox(height: 20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cor.nomeCor,
                  style: TextStyle(
                      fontSize: 60, fontFamily: "Kanit", color: cor.colors),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      verificaEscolha("Azul");
                      cor.nomeCor = geraCorEscrita();
                      cor.colors = geraCor();
                    });
                  },
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    color: Colors.blue,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      verificaEscolha("Amarelo");
                      cor.nomeCor = geraCorEscrita();
                      cor.colors = geraCor();
                    });
                  },
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    color: Colors.yellow,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      verificaEscolha("Vermelho");
                      cor.nomeCor = geraCorEscrita();
                      cor.colors = geraCor();
                    });
                  },
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    color: Colors.red,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      verificaEscolha("Verde");
                      cor.nomeCor = geraCorEscrita();
                      cor.colors = geraCor();
                    });
                  },
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    color: Colors.green,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      verificaEscolha("Preto");
                      cor.nomeCor = geraCorEscrita();
                      cor.colors = geraCor();
                    });
                  },
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 70),
            ),
            Row(
              children: [
                Text('Acertos: ${contadorAcertos._valor}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: "Kanit")),
              ],
            ),
            Row(
              children: [
                Text('Erros: ${erros._valor}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: "Kanit")),
              ],
            ),
            Row(
              children: [
                Text('Contador:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: "Kanit")),
                Text(_formatTime(_counter),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: "Kanit")),
              ],
            ),
            Row(
              children: [
                Text("Estágio: ${contJogadas._valor}/15",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: "Kanit")),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    contJogadas = Inteiro(0);
                    contadorAcertos = Inteiro(0);
                    tempoFinal = Inteiro(0);
                    pontuacao = Double(0);
                    _counter = 0;
                    _timer.cancel();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelecionarJogo()));
                  },
                  child: Container(
                    height: 50,
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                        child: Text(
                      "Voltar",
                      style: TextStyle(fontSize: 24, fontFamily: "Inter"),
                    )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> enviarPontuacaoStroopLevel1(Usuario user, PontuacaoStroop pontuacao, int num) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/stroop/${user.usuario}/${num}.json";

  try {
    await http.put(
      Uri.parse(url),
      body: json.encode(pontuacao.toMap()),
    );
  } catch (error) {
    print(error);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CorApp();
  }
}
