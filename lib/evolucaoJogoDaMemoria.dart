import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'jogoDaMemoria.dart';
import 'usuarios.dart';

void main() async {
  runApp(EvolucaoAppJogoDaMemoria());
}

class EvolucaoAppJogoDaMemoria extends StatefulWidget {
  @override
  _EvolucaoAppJogoDaMemoriaState createState() =>
      _EvolucaoAppJogoDaMemoriaState();
}

Future<int> recuperarNumMemoria(Usuario user) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/jogoDaMemoria/${user.nome}/.json";
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

Future<List<PontuacaoJogoDaMemoria>> recuperarPontuacao(Usuario user) async {
  List<PontuacaoJogoDaMemoria> pontuacoes = [];
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/jogoDaMemoria/${user.nome}/.json";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data is List) {
        for (dynamic item in data) {
          pontuacoes.add(PontuacaoJogoDaMemoria.fromMap(item));
        }
      } else if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          pontuacoes.add(PontuacaoJogoDaMemoria.fromMap(value));
        });
      } else {
        print("Erro: Dados inesperados recebidos do Firebase");
      }
    } else {
      print("Erro na requisição: ${response.statusCode}");
    }
  } catch (error) {
    print(error);
  }

  primeiraPontuacaoJM.tempo = pontuacoes[0].tempo;
  primeiraPontuacaoJM.errosTotal = pontuacoes[0].errosTotal;
  primeiraPontuacaoJM.errosBaleia = pontuacoes[0].errosBaleia;
  primeiraPontuacaoJM.errosPinguim = pontuacoes[0].errosPinguim;
  primeiraPontuacaoJM.errosPolvo = pontuacoes[0].errosPolvo;
  indexJMP = 1;

  ultimaPontuacaoJM.tempo = pontuacoes[(pontuacoes.length - 1)].tempo;
  ultimaPontuacaoJM.errosTotal = pontuacoes[(pontuacoes.length - 1)].errosTotal;
  ultimaPontuacaoJM.errosBaleia =
      pontuacoes[(pontuacoes.length - 1)].errosBaleia;
  ultimaPontuacaoJM.errosPinguim =
      pontuacoes[(pontuacoes.length - 1)].errosPinguim;
  ultimaPontuacaoJM.errosPolvo = pontuacoes[(pontuacoes.length - 1)].errosPolvo;
  indexJMU = pontuacoes.length;

  melhorPontuacaoJM.tempo = pontuacoes[geraPontuacoes(pontuacoes)].tempo;
  melhorPontuacaoJM.errosTotal =
      pontuacoes[geraPontuacoes(pontuacoes)].errosTotal;
  melhorPontuacaoJM.errosBaleia =
      pontuacoes[geraPontuacoes(pontuacoes)].errosBaleia;
  melhorPontuacaoJM.errosPinguim =
      pontuacoes[geraPontuacoes(pontuacoes)].errosPinguim;
  melhorPontuacaoJM.errosPolvo =
      pontuacoes[geraPontuacoes(pontuacoes)].errosPolvo;
  indexJMM = geraPontuacoes(pontuacoes) + 1;

  return pontuacoes;
}

int geraPontuacoes(List<PontuacaoJogoDaMemoria> pontuacoesEnviada) {
  int maiorPontuacao =
      100 - (pontuacoesEnviada[0].tempo + pontuacoesEnviada[0].errosTotal);
  int index = 0;

  for (int i = 0; i < pontuacoesEnviada.length; i++) {
    if (100 - (pontuacoesEnviada[i].tempo + pontuacoesEnviada[i].errosTotal) >
        maiorPontuacao) {
      index = i;
    }
  }

  return index;
}

class _EvolucaoAppJogoDaMemoriaState extends State<EvolucaoAppJogoDaMemoria> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    TelaPrincipal(),
    TelaUsuarios(),
    TelaJogoDaMemoria(),
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
            SizedBox(height: 20),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "Jogo da Memória",
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
                width: 430,
                color: Colors.black,
              ),
            ]),
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
                child: Container(
              width: 400,
              height: 450,
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
                        'Jogada de número 1',
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
                          'Erros selecionando a figura do polvo',
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
                        '${primeiraPontuacaoJM.errosPolvo}',
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
                          'Erros selecionando a figura do penguim',
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
                        '${primeiraPontuacaoJM.errosPinguim}',
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
                          'Erros selecionando a figura da baleia',
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
                        '${primeiraPontuacaoJM.errosBaleia}',
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
                          'Erros no total para completar o jogo',
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
                        '${primeiraPontuacaoJM.errosTotal}',
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
                        '${primeiraPontuacaoJM.tempo}',
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
            SizedBox(height: 20),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "Jogo da Memória",
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
              height: 450,
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
                        'Jogada de número ${indexJMU}',
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
                          'Erros selecionando a figura do polvo',
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
                        '${ultimaPontuacaoJM.errosPolvo}',
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
                          'Erros selecionando a figura do penguim',
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
                        '${ultimaPontuacaoJM.errosPinguim}',
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
                          'Erros selecionando a figura da baleia',
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
                        '${ultimaPontuacaoJM.errosBaleia}',
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
                          'Erros no total para completar o jogo',
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
                        '${ultimaPontuacaoJM.errosTotal}',
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
                        '${ultimaPontuacaoJM.tempo}',
                        style:
                            TextStyle(fontSize: 19, fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
              ]),
            )),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(children: [
              Padding(padding: EdgeInsets.only(left: 10)),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelecionarJogoEvolucao()));
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
            ]),
          ],
        ),
      ],
    );
  }
}

class TelaJogoDaMemoria extends StatelessWidget {
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
            SizedBox(height: 20),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "Jogo da Memória",
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
              height: 450,
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
                        'Jogada de número ${indexJMM}',
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
                          'Erros selecionando a figura do polvo',
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
                        '${melhorPontuacaoJM.errosPolvo}',
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
                          'Erros selecionando a figura do penguim',
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
                        '${melhorPontuacaoJM.errosPinguim}',
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
                          'Erros selecionando a figura da baleia',
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
                        '${melhorPontuacaoJM.errosBaleia}',
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
                          'Erros no total para completar o jogo',
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
                        '${melhorPontuacaoJM.errosTotal}',
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
                        '${melhorPontuacaoJM.tempo}',
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
        ]),
      ],
    );
  }
}
