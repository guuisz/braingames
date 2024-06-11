import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'sequenciaDeCores.dart';
import 'usuarios.dart';

void main() async {
  runApp(EvolucaoAppSequencia());
}

class EvolucaoAppSequencia extends StatefulWidget {
  @override
  _EvolucaoAppSequenciaState createState() => _EvolucaoAppSequenciaState();
}

Future<List<PontuacaoSequencia>> recuperarPontuacaoSeq(Usuario user) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/sequenciaCores/${user.nome}/.json";
  List<PontuacaoSequencia> pontuacoes = [];

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data == null) {
        print("Dados vazios recebidos do Firebase");
      } else if (data is List) {
        for (dynamic item in data) {
          pontuacoes.add(PontuacaoSequencia.fromMap(item));
        }
      } else if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          pontuacoes.add(PontuacaoSequencia.fromMap(value));
        });
      } else {
        print("Erro: Dados inesperados recebidos do Firebase");
      }
    } else {
      print("Erro na requisição: ${response.statusCode}");
    }
  } catch (error) {
    print("Erro na recuperação dos dados: $error");
  }

  primeiraPontuacaoSeq.tempo = pontuacoes[0].tempo;
  primeiraPontuacaoSeq.tentativasEstagioUm = pontuacoes[0].tentativasEstagioUm;
  primeiraPontuacaoSeq.tentativasEstagioDois =
      pontuacoes[0].tentativasEstagioDois;
  primeiraPontuacaoSeq.tentativasEstagioTres =
      pontuacoes[0].tentativasEstagioTres;
  primeiraPontuacaoSeq.tentativasEstagioQuatro =
      pontuacoes[0].tentativasEstagioQuatro;
  primeiraPontuacaoSeq.errosTotais = pontuacoes[0].errosTotais;
  indexSP = 1;

  ultimaPontuacaoSeq.tempo = pontuacoes[(pontuacoes.length - 1)].tempo;
  ultimaPontuacaoSeq.tentativasEstagioUm =
      pontuacoes[(pontuacoes.length - 1)].tentativasEstagioUm;
  ultimaPontuacaoSeq.tentativasEstagioDois =
      pontuacoes[(pontuacoes.length - 1)].tentativasEstagioDois;
  ultimaPontuacaoSeq.tentativasEstagioTres =
      pontuacoes[(pontuacoes.length - 1)].tentativasEstagioTres;
  ultimaPontuacaoSeq.tentativasEstagioQuatro =
      pontuacoes[(pontuacoes.length - 1)].tentativasEstagioQuatro;
  ultimaPontuacaoSeq.errosTotais =
      pontuacoes[(pontuacoes.length - 1)].errosTotais;
  indexSUP = pontuacoes.length;

  melhorPontuacaoSeq.tempo = pontuacoes[geraPontuacoes(pontuacoes)].tempo;
  melhorPontuacaoSeq.tentativasEstagioUm =
      pontuacoes[geraPontuacoes(pontuacoes)].tentativasEstagioUm;
  melhorPontuacaoSeq.tentativasEstagioDois =
      pontuacoes[geraPontuacoes(pontuacoes)].tentativasEstagioDois;
  melhorPontuacaoSeq.tentativasEstagioTres =
      pontuacoes[geraPontuacoes(pontuacoes)].tentativasEstagioTres;
  melhorPontuacaoSeq.tentativasEstagioQuatro =
      pontuacoes[geraPontuacoes(pontuacoes)].tentativasEstagioQuatro;
  melhorPontuacaoSeq.errosTotais =
      pontuacoes[geraPontuacoes(pontuacoes)].errosTotais;
  indexSMP = geraPontuacoes(pontuacoes) + 1;

  return pontuacoes;
}

Future<int> recuperarNum(Usuario user) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/sequenciaCores/${user.usuario}/.json";
  int pontuacoes = 0;

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data == null) {
        print("Dados vazios recebidos do Firebase");
      } else if (data is List) {
        for (dynamic item in data) {
          pontuacoes += 1;
        }
      } else if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          pontuacoes += 1;
        });
      } else {
        print("Erro: Dados inesperados recebidos do Firebase");
      }
    } else {
      print("Erro na requisição: ${response.statusCode}");
    }
  } catch (error) {
    print("Erro na recuperação dos dados: $error");
  }

  return pontuacoes;
}

int geraPontuacoes(List<PontuacaoSequencia> pontuacoesEnviada) {
  int maiorPontuacao =
      100 - (pontuacoesEnviada[0].tempo + pontuacoesEnviada[0].errosTotais);
  int index = 0;

  for (int i = 0; i < pontuacoesEnviada.length; i++) {
    if (100 - (pontuacoesEnviada[i].tempo + pontuacoesEnviada[i].errosTotais) >
        maiorPontuacao) {
      index = i;
    }
  }

  return index;
}

class _EvolucaoAppSequenciaState extends State<EvolucaoAppSequencia> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    TelaPrincipal(),
    TelaUsuarios(),
    TelaSequencia(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.first_page),
              label: 'Primeira Jogada',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.last_page),
              label: 'Última Jogada',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_arrow_up),
              label: 'Melhor Jogada',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromRGBO(33, 150, 234, 1.0),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          Row(children: [
            Padding(padding: EdgeInsets.only(left: 10)),
          ]),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
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
              Padding(padding: EdgeInsets.only(left: 20)),
              Container(
                height: 1,
                width: 480,
                color: Colors.black,
              ),
            ]),
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
                child: Container(
              width: 400,
              height: 500,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 100),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                  "Primeira Jogada",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: "Montserrat"),
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Número da Jogada',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        'Jogada de número ${indexSP}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a primeira fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${primeiraPontuacaoSeq.tentativasEstagioUm}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a segunda fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${primeiraPontuacaoSeq.tentativasEstagioDois}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a teceira fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${primeiraPontuacaoSeq.tentativasEstagioTres}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a quarta fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${primeiraPontuacaoSeq.tentativasEstagioQuatro}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas totais até o jogo',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${primeiraPontuacaoSeq.errosTotais}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tempo total para completar o jogo',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${primeiraPontuacaoSeq.tempo}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
              ]),
            )),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelecionarJogoEvolucao()));
            },
            child: Container(
              height: 30,
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
        ]),
      ],
    );
  }
}

class TelaUsuarios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          Row(children: [
            Padding(padding: EdgeInsets.only(left: 10)),
          ]),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
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
              Padding(padding: EdgeInsets.only(left: 20)),
              Container(
                height: 1,
                width: 280,
                color: Colors.black,
              ),
            ]),
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
                child: Container(
              width: 400,
              height: 500,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 100),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                  "Última Jogada",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: "Montserrat"),
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Número da Jogada',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        'Jogada de número ${indexSUP}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a primeira fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${ultimaPontuacaoSeq.tentativasEstagioUm}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a segunda fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${ultimaPontuacaoSeq.tentativasEstagioDois}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a teceira fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${ultimaPontuacaoSeq.tentativasEstagioTres}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a quarta fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${ultimaPontuacaoSeq.tentativasEstagioQuatro}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas totais até o jogo',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${ultimaPontuacaoSeq.errosTotais}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tempo total para completar o jogo',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${ultimaPontuacaoSeq.tempo}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
              ]),
            )),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelecionarJogoEvolucao()));
            },
            child: Container(
              height: 30,
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
        ]),
      ],
    );
  }
}

class TelaSequencia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          Row(children: [
            Padding(padding: EdgeInsets.only(left: 10)),
          ]),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
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
              Padding(padding: EdgeInsets.only(left: 20)),
              Container(
                height: 1,
                width: 280,
                color: Colors.black,
              ),
            ]),
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
                child: Container(
              width: 400,
              height: 500,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 100),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                  "Melhor Jogada",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: "Montserrat"),
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Número da Jogada',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        'Jogada de número ${indexSMP}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a primeira fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${melhorPontuacaoSeq.tentativasEstagioUm}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a segunda fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${melhorPontuacaoSeq.tentativasEstagioDois}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a teceira fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${melhorPontuacaoSeq.tentativasEstagioTres}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas até concluir a quarta fase',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${melhorPontuacaoSeq.tentativasEstagioQuatro}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tentativas totais até o jogo',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${primeiraPontuacaoSeq.errosTotais}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Tempo total para completar o jogo',
                          style:
                              TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                    Container(
                      width: 380,
                      height: 25,
                      color: Colors.white,
                      child: Text(
                        '${melhorPontuacaoSeq.tempo}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
              ]),
            )),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelecionarJogoEvolucao()));
            },
            child: Container(
              height: 30,
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
        ]),
      ],
    );
  }
}
