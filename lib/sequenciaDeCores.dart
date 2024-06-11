import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';
import 'usuarios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Inteiro {
  int _valor;
  Inteiro(this._valor);

  int get valor => _valor;

  void incrementar() {
    _valor++;
  }
}

class EstagioPontuacao {
  int _valor;
  bool _estagioOn;
  EstagioPontuacao(this._valor, this._estagioOn);

  int get valor => _valor;
  bool get estagioOn => _estagioOn;

  void incrementar() {
    _valor++;
  }
}

EstagioPontuacao tentativasEstagioUm = EstagioPontuacao(0, true);
EstagioPontuacao tentativasEstagioDois = EstagioPontuacao(0, false);
EstagioPontuacao tentativasEstagioTres = EstagioPontuacao(0, false);
EstagioPontuacao tentativasEstagioQuatro = EstagioPontuacao(0, false);
Inteiro estagioAtual = Inteiro(1);
Inteiro errosTotais = Inteiro(0);
Inteiro contadorDeCliques = Inteiro(0);

class PontuacaoSequencia {
  late int tempo;
  late int tentativasEstagioUm;
  late int tentativasEstagioDois;
  late int tentativasEstagioTres;
  late int tentativasEstagioQuatro;
  late int errosTotais;

  PontuacaoSequencia({
    required this.tempo,
    required this.tentativasEstagioUm,
    required this.tentativasEstagioDois,
    required this.tentativasEstagioTres,
    required this.tentativasEstagioQuatro,
    required this.errosTotais,
  });

  Map<String, dynamic> toMap() {
    return {
      'tempo': tempo,
      'tentativas estagio 1': tentativasEstagioUm,
      'tentativas estagio 2': tentativasEstagioDois,
      'tentativas estagio 3': tentativasEstagioTres,
      'tentativas estagio 4': tentativasEstagioQuatro,
      'erros total': errosTotais,
    };
  }

  factory PontuacaoSequencia.fromMap(Map<String, dynamic> map) {
    return PontuacaoSequencia(
      tempo: map['tempo'],
      tentativasEstagioUm: map['tentativas estagio 1'],
      tentativasEstagioDois: map['tentativas estagio 2'],
      tentativasEstagioTres: map['tentativas estagio 3'],
      tentativasEstagioQuatro: map['tentativas estagio 4'],
      errosTotais: map['erros total'],
    );
  }
}

void main() {
  runApp(seqCores());
}

class seqApp extends StatefulWidget {
  @override
  _seqAppState createState() => _seqAppState();
}

class _seqAppState extends State<seqApp> {
  void finalizarJogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Jogo finalizado'),
          content: Text(
              'Você Terminou o jogo! Seu tempo foi de ${_counter} segundos'),
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

  Color corVerde = Colors.green;
  Color corVermelha = Colors.red;
  Color corAmarela = Colors.yellow;
  Color corAzul = Colors.blue;

  Inteiro contador = Inteiro(1);
  EstagioPontuacao tentativasEstagioUm = EstagioPontuacao(0, true);
  EstagioPontuacao tentativasEstagioDois = EstagioPontuacao(0, false);
  EstagioPontuacao tentativasEstagioTres = EstagioPontuacao(0, false);
  EstagioPontuacao tentativasEstagioQuatro = EstagioPontuacao(0, false);
  Inteiro estagioAtual = Inteiro(1);
  Inteiro errosTotais = Inteiro(0);
  Inteiro contadorDeCliques = Inteiro(0);

  List<int> numerosSelecionadosLevel1 = [];

  Future<void> geraNumeros() async {
    Random random = Random();
    numerosSelecionadosLevel1.add(random.nextInt(4));
    numerosSelecionadosLevel1.add(random.nextInt(4));
    numerosSelecionadosLevel1.add(random.nextInt(4));
    numerosSelecionadosLevel1.add(random.nextInt(4));
  }

  Future<void> verificaAcerto(int corClicada) async {
    if (numerosSelecionadosLevel1[contadorDeCliques._valor] == corClicada) {
      contadorDeCliques.incrementar();
      if (contadorDeCliques._valor == contador._valor) {
        estagioAtual.incrementar();
        if (tentativasEstagioUm._estagioOn == true) {
          tentativasEstagioUm._estagioOn = false;
          tentativasEstagioDois._estagioOn = true;
        } else if (tentativasEstagioDois._estagioOn == true) {
          tentativasEstagioDois._estagioOn = false;
          tentativasEstagioTres._estagioOn = true;
        } else if (tentativasEstagioTres._estagioOn == true) {
          tentativasEstagioTres._estagioOn = false;
          tentativasEstagioQuatro._estagioOn = true;
        }
        contador.incrementar();
        contadorDeCliques._valor = 0;
      }
    } else {
      errosTotais.incrementar();
      if (tentativasEstagioUm._estagioOn == true) {
        tentativasEstagioUm.incrementar();
      } else if (tentativasEstagioDois._estagioOn == true) {
        tentativasEstagioDois.incrementar();
      } else if (tentativasEstagioTres._estagioOn == true) {
        tentativasEstagioTres.incrementar();
      } else if (tentativasEstagioQuatro._estagioOn == true) {
        tentativasEstagioQuatro.incrementar();
      }
      contadorDeCliques._valor = 0;
    }

    print('Erros na tentativa um: ${tentativasEstagioUm._valor}');
    print('Erros na tentativa dois: ${tentativasEstagioDois._valor}');
    print('Erros na tentativa três: ${tentativasEstagioTres._valor}');
    print('Erros na tentativa quatro: ${tentativasEstagioQuatro._valor}');
  }

  Future<void> AlteraCor(int num) async {
    print('Início da AlteraCor');

    switch (num) {
      case 0:
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corVerde = Colors.greenAccent;
        });
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corVerde = Colors.green;
        });
        break;
      case 1:
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corVermelha = Colors.redAccent;
        });
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corVermelha = Colors.red;
        });
        break;
      case 2:
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corAmarela = Colors.yellowAccent;
        });
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corAmarela = Colors.yellow;
        });
        break;
      case 3:
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corAzul = Colors.blueAccent;
        });
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          corAzul = Colors.blue;
        });
        break;
    }

    print('Fim da AlteraCor');
  }

  Future<void> rodaJogo() async {
    for (int i = 0; i < contador._valor; i++) {
      print(i);
      await AlteraCor(numerosSelecionadosLevel1[i]);
    }
  }

  int _counter = 0;
  late Timer _timer;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    geraNumeros();
    super.initState();
    Timer(Duration(seconds: 3), () {
      rodaJogo();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (contador._valor <= 4) {
          _incrementCounter();
        } else {
          PontuacaoSequencia pontuacaoUsuario = new PontuacaoSequencia(
              tempo: _counter,
              tentativasEstagioUm: tentativasEstagioUm._valor,
              tentativasEstagioDois: tentativasEstagioDois._valor,
              tentativasEstagioTres: tentativasEstagioTres._valor,
              tentativasEstagioQuatro: tentativasEstagioQuatro._valor,
              errosTotais: errosTotais._valor);
          _timer.cancel();
          finalizarJogo(context);
          enviarPontuacaoStroopLevel1(
              usuario, pontuacaoUsuario, numeroSequencia);
        }
      });
    });
  }

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
                  CrossAxisAlignment.start, // Alinha os itens no início
              children: [
                SizedBox(height: 20), // Ad
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      "Sequência de Cores",
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
                    width: 480,
                    color: Colors.black,
                  ),
                ]),
                SizedBox(height: 20),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () async {
                  await verificaAcerto(0);
                  if (contadorDeCliques._valor == 0) {
                    await rodaJogo();
                  }
                },
                child: Container(
                  color: corVerde,
                  width: 200,
                  height: 200,
                ),
              ),
              InkWell(
                onTap: () async {
                  await verificaAcerto(1);
                  if (contadorDeCliques._valor == 0) {
                    await rodaJogo();
                  }
                },
                child: Container(
                  color: corVermelha,
                  width: 200,
                  height: 200,
                ),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () async {
                  await verificaAcerto(2);
                  if (contadorDeCliques._valor == 0) {
                    await rodaJogo();
                  }
                },
                child: Container(
                  color: corAmarela,
                  width: 200,
                  height: 200,
                ),
              ),
              InkWell(
                onTap: () async {
                  await verificaAcerto(3);
                  if (contadorDeCliques._valor == 0) {
                    await rodaJogo();
                  }
                },
                child: Container(
                  color: corAzul,
                  width: 200,
                  height: 200,
                ),
              ),
            ]),
            Row(
              children: [
                Text('Estágio: ${estagioAtual._valor}/4',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: "Inter")),
              ],
            ),
            Row(
              children: [
                Text('Erros Totais: ${errosTotais._valor}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: "Inter")),
              ],
            ),
            Row(
              children: [
                Text('Contador:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: "Inter")),
                Text(_formatTime(_counter),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: "Inter")),
              ],
            ),
            InkWell(
              onTap: () {
                contador = Inteiro(1);
                contadorDeCliques = Inteiro(0);
                _timer.cancel();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelecionarJogo()));
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
        ),
      ),
    );
  }
}

class seqCores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return seqApp();
  }
}

Future<void> enviarPontuacaoStroopLevel1(
    Usuario user, PontuacaoSequencia pontuacao, int num) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/sequenciaCores/${user.usuario}/${num}.json";

  try {
    await http.put(
      Uri.parse(url),
      body: json.encode(pontuacao.toMap()),
    );
  } catch (error) {
    print(error);
  }
}


