import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'stroop.dart';
import 'usuarios.dart';

void main() async {
  runApp(EvolucaoAppStroop());
}

class EvolucaoAppStroop extends StatefulWidget {
  @override
  __EvolucaoAppStroopState createState() => __EvolucaoAppStroopState();
}

Future<List<PontuacaoStroop>> recuperarPontuacaoStroop(Usuario user) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/stroop/${usuario.nome}/.json";
  List<PontuacaoStroop> pontuacoes = [];

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data == null) {
        print("Dados vazios recebidos do Firebase");
      } else if (data is List) {
        for (dynamic item in data) {
          pontuacoes.add(PontuacaoStroop.fromMap(item));
        }
      } else if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          pontuacoes.add(PontuacaoStroop.fromMap(value));
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

  primeiraPontuacaoST.tempo = pontuacoes[0].tempo;
  primeiraPontuacaoST.acertos = pontuacoes[0].acertos;
  primeiraPontuacaoST.erros = pontuacoes[0].erros;
  primeiraPontuacaoST.errosCorCongruentes = pontuacoes[0].errosCorCongruentes;
  primeiraPontuacaoST.errosCorNaoCongruentes =
      pontuacoes[0].errosCorNaoCongruentes;
  indexSTPJ = 1;

  ultimaPontuacaoST.tempo = pontuacoes[(pontuacoes.length - 1)].tempo;
  ultimaPontuacaoST.acertos = pontuacoes[(pontuacoes.length - 1)].acertos;
  ultimaPontuacaoST.erros = pontuacoes[(pontuacoes.length - 1)].erros;
  ultimaPontuacaoST.errosCorCongruentes =
      pontuacoes[(pontuacoes.length - 1)].errosCorCongruentes;
  ultimaPontuacaoST.errosCorNaoCongruentes =
      pontuacoes[(pontuacoes.length - 1)].errosCorNaoCongruentes;
  indexSTUJ = pontuacoes.length;

  melhorPontuacaoST.tempo = pontuacoes[geraPontuacoesStroop(pontuacoes)].tempo;
  melhorPontuacaoST.acertos =
      pontuacoes[geraPontuacoesStroop(pontuacoes)].acertos;
  melhorPontuacaoST.erros = pontuacoes[geraPontuacoesStroop(pontuacoes)].erros;
  melhorPontuacaoST.errosCorCongruentes =
      pontuacoes[geraPontuacoesStroop(pontuacoes)].errosCorCongruentes;
  melhorPontuacaoST.errosCorNaoCongruentes =
      pontuacoes[geraPontuacoesStroop(pontuacoes)].errosCorNaoCongruentes;
  indexSTMJ = geraPontuacoesStroop(pontuacoes) + 1;

  return pontuacoes;
}

Future<int> recuperarNumStroop(Usuario user) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/stroop/${user.usuario}/.json";
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

int geraPontuacoesStroop(List<PontuacaoStroop> pontuacoesEnviada) {
  double pesoAcertos = 10.0; // Peso para acertos
  double pesoErros = 5.0; // Peso para erros
  double pesoTempo = 2.0; // Peso para tempo

  int maiorPontuacao = (pesoAcertos * pontuacoesEnviada[0].acertos -
          pesoErros *
              (pontuacoesEnviada[0].erros -
                  pesoTempo * pontuacoesEnviada[0].tempo))
      .toInt();
  int index = 0;

  for (int i = 0; i < pontuacoesEnviada.length; i++) {
    if ((pesoAcertos * pontuacoesEnviada[i].acertos -
                pesoErros *
                    (pontuacoesEnviada[i].erros -
                        pesoTempo * pontuacoesEnviada[i].tempo))
            .toInt() >
        maiorPontuacao) {
      index = i;
    }
  }

  return index;
}

class __EvolucaoAppStroopState extends State<EvolucaoAppStroop> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    TelaPrincipal(),
    TelaUsuarios(),
    TelaStroop(),
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
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Container(
                    height: 1,
                    width: 160,
                    color: Colors.black,
                  ),
                ]),
                Padding(padding: EdgeInsets.only(top: 20)),
                Center(
                    child: Container(
                  width: 400,
                  height: 400,
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
                            Text('Número da Jogada'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            'Jogada de número ${indexSTPJ}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Acertos'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${primeiraPontuacaoST.acertos}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Erros cor apresentada congruente'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${primeiraPontuacaoST.errosCorCongruentes}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Erros cor apresentada não congruente'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${primeiraPontuacaoST.errosCorNaoCongruentes}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                                'Erros no total para completar o jogo'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${primeiraPontuacaoST.erros}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Tempo total para completar o jogo'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${primeiraPontuacaoST.tempo}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
        ),
      ),
    );
  }
}

class TelaUsuarios extends StatelessWidget {
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
                  height: 400,
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
                            Text('Número da Jogada'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            'Jogada de número ${indexSTUJ}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Acertos'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${ultimaPontuacaoST.acertos}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Erros cor apresentada congruente'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${ultimaPontuacaoST.errosCorCongruentes}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Erros cor apresentada não congruente'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${ultimaPontuacaoST.errosCorNaoCongruentes}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                                'Erros no total para completar o jogo'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${ultimaPontuacaoST.erros}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Tempo total para completar o jogo'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${ultimaPontuacaoST.tempo}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
        ),
      ),
    );
  }
}

class TelaStroop extends StatelessWidget {
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
                  height: 400,
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
                            Text('Número da Jogada'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            'Jogada de número ${indexSTMJ}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Acertos'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${melhorPontuacaoST.acertos}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Erros cor apresentada congruente'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${melhorPontuacaoST.errosCorCongruentes}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Erros cor apresentada não congruente'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${melhorPontuacaoST.errosCorNaoCongruentes}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                                'Erros no total para completar o jogo'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${melhorPontuacaoST.erros}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
                            Text('Tempo total para completar o jogo'),
                          ],
                        ),
                        Container(
                          width: 380,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            '${melhorPontuacaoST.tempo}',
                            style: TextStyle(
                                fontSize: 19, fontFamily: "Montserrat"),
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
        ),
      ),
    );
  }
}
