import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'usuarios.dart';
import 'main.dart';

class PontuacaoJogoDaMemoria {
  late int tempo;
  late int errosTotal;
  late int errosPinguim;
  late int errosPolvo;
  late int errosBaleia;
  late int index;

  PontuacaoJogoDaMemoria({
    required this.tempo,
    required this.errosTotal,
    required this.errosPinguim,
    required this.errosPolvo,
    required this.errosBaleia,
  });

  Map<String, dynamic> toMap() {
    return {
      'tempo': tempo,
      'erros total': errosTotal,
      'erros pinguim': errosPinguim,
      'erros polvo': errosPolvo,
      'erros baleia': errosBaleia,
    };
  }

  factory PontuacaoJogoDaMemoria.fromMap(Map<String, dynamic> map) {
    return PontuacaoJogoDaMemoria(
      tempo: map['tempo'],
      errosTotal: map['erros total'],
      errosPinguim: map['erros pinguim'],
      errosPolvo: map['erros polvo'],
      errosBaleia: map['erros baleia'],
    );
  }
}

class sequenciaImagem {
  String _imagemUm;
  int _indiceUm;
  String _imagemDois;
  int _indiceDois;

  sequenciaImagem(
      this._imagemUm, this._indiceUm, this._imagemDois, this._indiceDois);

  String get imagemUm => _imagemUm;
  int get indiceUm => _indiceUm;
  String get imagemDois => _imagemDois;
  int get indiceDois => _indiceDois;
}

void main() async {
  runApp(JogoDaMemoriaApp());
}

class JogoDaMemoriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JogoDaMemoriaPage(),
    );
  }
}

class JogoDaMemoriaPage extends StatefulWidget {
  @override
  _JogoDaMemoriaPageState createState() => _JogoDaMemoriaPageState();
}

class Imagem {
  String _imagemOriginal;
  String _imagemAtual;
  bool _result;
  bool _errou;

  Imagem(this._imagemOriginal, this._imagemAtual, this._result, this._errou);

  String get imagemOriginal => _imagemOriginal;
  String get imagemAtual => _imagemAtual;
  bool get result => _result;
  bool get errou => _errou;
}

class Inteiro {
  int _valor;
  Inteiro(this._valor);

  int get valor => _valor;

  void incrementar() {
    _valor++;
  }
}

class _JogoDaMemoriaPageState extends State<JogoDaMemoriaPage> {
  void finalizarJogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Jogo finalizado'),
          content: Text(
              'Você Terminou o jogo! Seu tempo foi de: ${_counter} segundos'),
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

  List<Imagem> listaImagens = [];
  sequenciaImagem seqImg = new sequenciaImagem('', -1, '', -1);

  Imagem imgUm = new Imagem('', '', false, false);
  Imagem imgDois = new Imagem('', '', false, false);
  Imagem imgTres = new Imagem('', '', false, false);
  Imagem imgQuatro = new Imagem('', '', false, false);
  Imagem imgCinco = new Imagem('', '', false, false);
  Imagem imgSeis = new Imagem('', '', false, false);

  int _counter = 0;
  late Timer _timer;

  Future<void> definaImagens() async {
    List<int> numerosSelecionados = [];
    List<String> imagens = [
      'imgs/pinguimCard.png',
      'imgs/pinguimCard.png',
      'imgs/polvoCard.png',
      'imgs/polvoCard.png',
      'imgs/baleiaCard.png',
      'imgs/baleiaCard.png',
    ];

    Random random = Random();
    int numeroSelecionado = random.nextInt(6);
    numerosSelecionados.add(numeroSelecionado);

    numeroSelecionado = random.nextInt(6);
    while (numerosSelecionados.contains(numeroSelecionado)) {
      numeroSelecionado = random.nextInt(6);
    }
    numerosSelecionados.add(numeroSelecionado);

    numeroSelecionado = random.nextInt(6);
    while (numerosSelecionados.contains(numeroSelecionado)) {
      numeroSelecionado = random.nextInt(6);
    }
    numerosSelecionados.add(numeroSelecionado);

    numeroSelecionado = random.nextInt(6);
    while (numerosSelecionados.contains(numeroSelecionado)) {
      numeroSelecionado = random.nextInt(6);
    }
    numerosSelecionados.add(numeroSelecionado);

    numeroSelecionado = random.nextInt(6);
    while (numerosSelecionados.contains(numeroSelecionado)) {
      numeroSelecionado = random.nextInt(6);
    }
    numerosSelecionados.add(numeroSelecionado);

    numeroSelecionado = random.nextInt(6);
    while (numerosSelecionados.contains(numeroSelecionado)) {
      numeroSelecionado = random.nextInt(6);
    }
    numerosSelecionados.add(numeroSelecionado);

    for (int i in numerosSelecionados) {
      print(i);
    }

    imgUm._imagemOriginal = imagens[numerosSelecionados[0]];
    imgUm._imagemAtual = imagens[numerosSelecionados[0]];
    imgDois._imagemOriginal = imagens[numerosSelecionados[1]];
    imgDois._imagemAtual = imagens[numerosSelecionados[1]];
    imgTres._imagemOriginal = imagens[numerosSelecionados[2]];
    imgTres._imagemAtual = imagens[numerosSelecionados[2]];
    imgQuatro._imagemOriginal = imagens[numerosSelecionados[3]];
    imgQuatro._imagemAtual = imagens[numerosSelecionados[3]];
    imgCinco._imagemOriginal = imagens[numerosSelecionados[4]];
    imgCinco._imagemAtual = imagens[numerosSelecionados[4]];
    imgSeis._imagemOriginal = imagens[numerosSelecionados[5]];
    imgSeis._imagemAtual = imagens[numerosSelecionados[5]];

    setState(() {
      Timer(Duration(seconds: 3), () {
        imgUm._imagemAtual = 'imgs/fundoImage.png';
        imgDois._imagemAtual = 'imgs/fundoImage.png';
        imgTres._imagemAtual = 'imgs/fundoImage.png';
        imgQuatro._imagemAtual = 'imgs/fundoImage.png';
        imgCinco._imagemAtual = 'imgs/fundoImage.png';
        imgSeis._imagemAtual = 'imgs/fundoImage.png';
      });
    });

    listaImagens.add(imgUm);
    listaImagens.add(imgDois);
    listaImagens.add(imgTres);
    listaImagens.add(imgQuatro);
    listaImagens.add(imgCinco);
    listaImagens.add(imgSeis);
  }

  void initState() {
    super.initState();
    definaImagens();
    Timer(Duration(seconds: 3), () {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _incrementCounter();
      });
    });
  }

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

  void alteraImagem(Imagem imagemEnviada) {
    setState(() {
      if (imagemEnviada.imagemAtual == 'imgs/fundoImage.png' &&
          imagemEnviada.errou == false) {
        if (imagemEnviada._result == false && imagemEnviada.errou == false) {
          imagemEnviada._imagemAtual = imagemEnviada._imagemOriginal;
        }
      }
    });
  }

  Inteiro paresFeitos = Inteiro(0);
  Inteiro errosTotal = Inteiro(0);
  Inteiro errosPinguim = Inteiro(0);
  Inteiro errosPolvo = Inteiro(0);
  Inteiro errosBaleia = Inteiro(0);

  void verificaJogo(Imagem imagemClicada, int indice) {
    if (seqImg._imagemUm == '' &&
        imagemClicada._result == false &&
        imagemClicada.errou == false) {
      imagemClicada._result = true;
      seqImg._imagemUm = imagemClicada._imagemOriginal;
      seqImg._indiceUm = indice;
    } else if (seqImg._imagemUm != "" &&
        imagemClicada._result == false &&
        imagemClicada.errou == false) {
      imagemClicada._result = true;
      seqImg._indiceDois = indice;
      seqImg._imagemDois = imagemClicada._imagemOriginal;
      if (seqImg._imagemUm == seqImg._imagemDois &&
          imagemClicada.errou == false) {
        print("Você acertou!");
        paresFeitos.incrementar();
        seqImg._imagemUm = '';
        seqImg._imagemDois = '';
        seqImg._indiceUm = -1;
        seqImg._indiceDois = -1;
      } else {
        if (seqImg._imagemUm == 'imgs/polvoCard.png') {
          print("Você errou a imagem do polvo");
          errosPolvo.incrementar();
        } else if (seqImg._imagemUm == 'imgs/pinguimCard.png') {
          print("Você errou a imagem do pinguim");
          errosPinguim.incrementar();
        } else {
          print("Você errou a imagem da baleia");
          errosBaleia.incrementar();
        }

        errosTotal.incrementar();

        for (Imagem i in listaImagens) {
          i._errou = true;
        }

        setState(() {
          Timer(Duration(milliseconds: 1500), () {
            listaImagens[seqImg._indiceUm]._imagemAtual = 'imgs/fundoImage.png';
            listaImagens[seqImg._indiceDois]._imagemAtual =
                'imgs/fundoImage.png';

            listaImagens[seqImg._indiceUm]._result = false;
            listaImagens[seqImg._indiceDois]._result = false;

            seqImg._imagemUm = '';
            seqImg._imagemDois = '';
            seqImg._indiceUm = -1;
            seqImg._indiceDois = -1;

            for (Imagem i in listaImagens) {
              i._errou = false;
            }
          });
        });
      }
    }

    bool venceu = true;
    for (Imagem img in listaImagens) {
      if (img._result == false) {
        venceu = false;
      }
    }

    if (venceu == true) {
      print('jogo acabou, o seu tempo foi de : ${_counter}');
      _timer.cancel();
      finalizarJogo(context);
      PontuacaoJogoDaMemoria pontuacaoUsuario = new PontuacaoJogoDaMemoria(
          tempo: _counter,
          errosTotal: errosTotal._valor,
          errosPinguim: errosPinguim._valor,
          errosBaleia: errosBaleia._valor,
          errosPolvo: errosPolvo._valor);
        enviarPontuacaoJogoDaMemoriaLevel1(
          usuario, pontuacaoUsuario, numeroJogoDaMemoria);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Jogo da memória",
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
                width: 430,
                color: Colors.black,
              ),
            ]),
            SizedBox(height: 20),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 50),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 20)),
            InkWell(
              onTap: () async {
                alteraImagem(imgUm);
                verificaJogo(imgUm, 0);
              },
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset(imgUm._imagemAtual),
              ),
            ),
            InkWell(
              onTap: () async {
                alteraImagem(imgDois);
                verificaJogo(imgDois, 1);
              },
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset(imgDois._imagemAtual),
              ),
            ),
            InkWell(
              onTap: () async {
                alteraImagem(imgTres);
                verificaJogo(imgTres, 2);
              },
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset(imgTres._imagemAtual),
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 50)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 20)),
            InkWell(
              onTap: () async {
                alteraImagem(imgQuatro);
                verificaJogo(imgQuatro, 3);
              },
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset(imgQuatro._imagemAtual),
              ),
            ),
            InkWell(
              onTap: () async {
                alteraImagem(imgCinco);
                verificaJogo(imgCinco, 4);
              },
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset(imgCinco._imagemAtual),
              ),
            ),
            InkWell(
              onTap: () async {
                alteraImagem(imgSeis);
                verificaJogo(imgSeis, 5);
              },
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset(imgSeis._imagemAtual),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('Combinações Feitas: ${paresFeitos._valor}/3',
                style: TextStyle(
                    color: Colors.black, fontSize: 30, fontFamily: "Inter")),
          ],
        ),
        Row(
          children: [
            Text('Erros: ${errosTotal._valor}',
                style: TextStyle(
                    color: Colors.black, fontSize: 30, fontFamily: "Inter")),
          ],
        ),
        Row(
          children: [
            Text('Contador:',
                style: TextStyle(
                    color: Colors.black, fontSize: 30, fontFamily: "Inter")),
            Text(_formatTime(_counter),
                style: TextStyle(
                    color: Colors.black, fontSize: 30, fontFamily: "Inter")),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        Row(
          children: [
            InkWell(
              onTap: () {
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
        )
      ],
    ));
  }
}

Future<void> enviarPontuacaoJogoDaMemoriaLevel1(
    Usuario user, PontuacaoJogoDaMemoria pontuacao, int num) async {
  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/pontuacoes/jogoDaMemoria/${user.usuario}/${num}.json";

  try {
    await http.put(
      Uri.parse(url),
      body: json.encode(pontuacao.toMap()),
    );
  } catch (error) {
    print(error);
  }
}
