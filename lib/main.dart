import 'package:flutter/material.dart';
import 'usuarios.dart';
import 'stroop.dart';
import 'sequenciaDeCores.dart';
import 'evolucaoStroop.dart';
import 'jogoDaMemoria.dart';
import 'evolucaoSequencia.dart';
import 'evolucaoJogoDaMemoria.dart';
import 'enviarComentario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
       debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void showSuccessMessageLogin(
    BuildContext context, String usuario, String senha) async {
  Usuario usuarioRecebido = await realizaLogin(usuario, senha);
  if (usuarioRecebido.nome == "") {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Erro! Usuario ou senha invalidos."),
      ),
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login realizado com sucesso!"),
      ),
    );
  }
}

//variaveis da tela de login
final TextEditingController _textEditingControllerUsuarioLogin =
    TextEditingController();
String _savedUsuarioLogin = "";

final TextEditingController _textEditingControllerSenhaLogin =
    TextEditingController();
String _savedSenhaLogin = "";

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset("imgs/friends1.png"),
            Text(
              "BrainGames",
              style: TextStyle(
                fontSize: 48,
                color: Colors.blue,
                fontFamily: "Montserrat",
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Image.asset("imgs/line1.png"),
            Padding(padding: EdgeInsets.only(top: 20)),
            TextField(
              controller: _textEditingControllerUsuarioLogin,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Usuario',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            TextField(
              controller: _textEditingControllerSenhaLogin,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            InkWell(
              onTap: () async {
                _savedUsuarioLogin = _textEditingControllerUsuarioLogin.text;
                _savedSenhaLogin = _textEditingControllerSenhaLogin.text;
                showSuccessMessageLogin(
                    context, _savedUsuarioLogin, _savedSenhaLogin);
                Usuario usuarioRecebido =
                    await realizaLogin(_savedUsuarioLogin, _savedSenhaLogin);
                usuario = usuarioRecebido;
                if (usuarioRecebido.nome != "") {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TelaDeSelecao()));
                }
              },
              child: Container(
                height: 50,
                width: 290,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(36, 255, 0, 100),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Container(
                  height: 50,
                  width: 290,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Entrar",
                    style: TextStyle(fontSize: 24, fontFamily: "Inter"),
                  )),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Image.asset("imgs/line1.png"),
            Padding(padding: EdgeInsets.only(top: 20)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaLogin()),
                );
              },
              child: Container(
                height: 50,
                width: 290,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(36, 255, 0, 100),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Center(
                    child: Text(
                  "Criar nova conta",
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

final TextEditingController _textEditingControllerEmail =
    TextEditingController();
String _savedEmail = "";

final TextEditingController _textEditingControllerUsuario =
    TextEditingController();
String _savedUsuario = "";

final TextEditingController _textEditingControllerSenha =
    TextEditingController();
String _savedSenha = "";

final TextEditingController _textEditingControllerNome =
    TextEditingController();
String _savedNome = "";

final TextEditingController _textEditingControllerDataDeNascimento =
    TextEditingController();
String _savedDataDeNascimento = "";

final TextEditingController _textEditingControllerGenero =
    TextEditingController();
String _savedGenero = "";

Usuario usuario = Usuario(
    nome: _savedNome,
    usuario: _savedUsuario,
    senha: _savedSenha,
    email: _savedEmail,
    dataDeNascimento: _savedDataDeNascimento,
    genero: _savedGenero);

int numeroStroop = 0;
int numeroSequencia = 0;

//mensagem de sucesso ao realizar cadastro
void showSuccessMessage(BuildContext context, bool cadastroRealizado) async {
  if (cadastroRealizado) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cadastro realizado com sucesso!"),
      ),
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Usuário ou email já contidos no sistema."),
      ),
    );
  }
}

//tela em si
class TelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text(
          "Criar Conta",
          style: TextStyle(
              fontSize: 48, color: Colors.blue, fontFamily: "Montserrat"),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        TextField(
          controller: _textEditingControllerNome,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nome',
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        TextField(
          controller: _textEditingControllerUsuario,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Usuario',
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        TextField(
          controller: _textEditingControllerSenha,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Senha',
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        TextField(
          controller: _textEditingControllerEmail,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'E-mail',
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        TextField(
          controller: _textEditingControllerDataDeNascimento,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Data de Nascimento',
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        TextField(
          controller: _textEditingControllerGenero,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Gênero',
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 40)),
        InkWell(
          onTap: () async {
            _savedNome = _textEditingControllerNome.text;
            _savedUsuario = _textEditingControllerUsuario.text;
            _savedSenha = _textEditingControllerSenha.text;
            _savedEmail = _textEditingControllerEmail.text;
            _savedDataDeNascimento =
                _textEditingControllerDataDeNascimento.text;
            _savedGenero = _textEditingControllerGenero.text;

            Usuario usuarioCadastro = Usuario(
                nome: _savedNome,
                usuario: _savedUsuario,
                senha: _savedSenha,
                email: _savedEmail,
                dataDeNascimento: _savedDataDeNascimento,
                genero: _savedGenero);
            bool cadastro = await enviarUsuarioParaOFireBase(usuarioCadastro);
            showSuccessMessage(context, cadastro);
          },
          child: Container(
            height: 50,
            width: 290,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(36, 255, 0, 100),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Center(
                child: Text(
              "Realizar cadastro",
              style: TextStyle(fontSize: 24, fontFamily: "Inter"),
            )),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        InkWell(
          onTap: () {
            Navigator.pop(context);
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
    ));
  }
}

// tela de escolha
class TelaDeSelecao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
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
                "Tela Inicial",
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
          SizedBox(height: 20),
        ],
      ),
      Row(children: [
        Padding(padding: EdgeInsets.only(left: 15)),
        Text(
          "Seleciona a opção: ",
          style:
              TextStyle(color: Colors.black, fontSize: 24, fontFamily: "Inter"),
        ),
      ]),
      Center(
        child: Column(children: [
          SizedBox(height: 30), // Ad
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SelecionarJogo()));
            },
            child: Container(
              height: 120,
              width: 370,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 0, 0, 80),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                  child: Text(
                "Jogar",
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: "Kanit"),
              )),
            ),
          ),
          SizedBox(height: 30), //
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelecionarJogoEvolucao()));
            },
            child: Container(
              height: 120,
              width: 370,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 0, 122, 80),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                  child: Text(
                "Resultados",
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: "Kanit"),
              )),
            ),
          ),
          SizedBox(height: 30), //
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => OiPage()));
            },
            child: Container(
              height: 120,
              width: 370,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 107, 0, 80),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                  child: Text(
                "Enviar Comentários",
                style: TextStyle(
                    color: Colors.white, fontSize: 40, fontFamily: "Kanit"),
              )),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
        ]),
      ),
      Row(children: [
        Padding(padding: EdgeInsets.only(left: 10)),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MyApp()));
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
      ])
    ]));
  }
}

int numeroJogoDaMemoria = 0;

//selecionar jogo
class SelecionarJogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
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
                    "Jogar",
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
                  width: 150,
                  color: Colors.black,
                ),
              ]),
              SizedBox(height: 20),
            ],
          ),
          Row(children: [
            Padding(padding: EdgeInsets.only(left: 15)),
            Text(
              "Selecionar o jogo: ",
              style: TextStyle(
                  color: Colors.black, fontSize: 24, fontFamily: "Inter"),
            ),
          ]),
          Padding(padding: EdgeInsets.only(top: 20)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Nivel1JogoDaMemoria()));
            },
            child: InkWell(
              onTap: () async {
                numeroJogoDaMemoria = await recuperarNumMemoria(usuario);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => JogoDaMemoriaApp()));
              },
              child: Container(
                height: 130,
                width: 370,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 0, 0, 80),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                    child: Text(
                  "Jogo da Memória",
                  style: TextStyle(
                      color: Colors.white, fontSize: 40, fontFamily: "Kanit"),
                )),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          InkWell(
            onTap: () async {
              numeroSequencia = await recuperarNum(usuario);

              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => seqCores()));
            },
            child: Container(
              height: 130,
              width: 370,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 255, 1, 80),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                  child: Text(
                "Sequência de Cores",
                style: TextStyle(
                    color: Colors.white, fontSize: 40, fontFamily: "Kanit"),
              )),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          InkWell(
            onTap: () async {
              numeroStroop = await recuperarNumStroop(usuario);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CorApp()));
            },
            child: Container(
              height: 130,
              width: 370,
              decoration: BoxDecoration(
                color: Color.fromRGBO(66, 0, 255, 80),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                  child: Text(
                "Stroop",
                style: TextStyle(
                    color: Colors.white, fontSize: 40, fontFamily: "Kanit"),
              )),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            Padding(padding: EdgeInsets.only(left: 10)),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TelaDeSelecao()));
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
          ])
        ]),
      ),
    );
  }
}

//niveis
class Nivel1JogoDaMemoria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: []),
      ),
    );
  }
}

//niveis
class Nivel1SequenciaDeCores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: []),
      ),
    );
  }
}

//niveis
class Nivel1Stroop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: []),
      ),
    );
  }
}

//evolução
class SelecionarJogoEvolucao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
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
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinha os itens no início
          children: [
            SizedBox(height: 20), // Ad
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "Evolução",
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
                width: 280,
                color: Colors.black,
              ),
            ]),
            SizedBox(height: 20),
          ],
        ),
        Row(children: [
          Padding(padding: EdgeInsets.only(left: 15)),
          Text(
            "Selecionar o jogo: ",
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontFamily: "Inter"),
          ),
        ]),
        Padding(padding: EdgeInsets.only(top: 20)),
        InkWell(
          onTap: () async {
            await recuperarPontuacao(usuario);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EvolucaoAppJogoDaMemoria()));
          },
          child: Container(
            height: 130,
            width: 370,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 0, 0, 80),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
                child: Text(
              "Jogo da Memória",
              style: TextStyle(
                  color: Colors.white, fontSize: 40, fontFamily: "Kanit"),
            )),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        InkWell(
          onTap: () async {
            await recuperarPontuacaoSeq(usuario);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EvolucaoAppSequencia()));
          },
          child: Container(
            height: 130,
            width: 370,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 255, 1, 80),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
                child: Text(
              "Sequência de Cores",
              style: TextStyle(
                  color: Colors.white, fontSize: 40, fontFamily: "Kanit"),
            )),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        InkWell(
          onTap: () async {
            await recuperarPontuacaoStroop(usuario);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EvolucaoAppStroop()));
          },
          child: Container(
            height: 130,
            width: 370,
            decoration: BoxDecoration(
              color: Color.fromRGBO(66, 0, 255, 80),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
                child: Text(""
              "Stroop",
              style: TextStyle(
                  color: Colors.white, fontSize: 40, fontFamily: "Kanit"),
            )),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        Row(children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaDeSelecao()));
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
        ])
      ]),
    );
  }
}

int indexJMP = 0;
PontuacaoJogoDaMemoria primeiraPontuacaoJM = PontuacaoJogoDaMemoria(
    tempo: 0, errosTotal: 0, errosPolvo: 0, errosBaleia: 0, errosPinguim: 0);
int indexJMU = 0;
PontuacaoJogoDaMemoria ultimaPontuacaoJM = PontuacaoJogoDaMemoria(
    tempo: 0, errosTotal: 0, errosPolvo: 0, errosBaleia: 0, errosPinguim: 0);
int indexJMM = 0;
PontuacaoJogoDaMemoria melhorPontuacaoJM = PontuacaoJogoDaMemoria(
    tempo: 0, errosTotal: 0, errosPolvo: 0, errosBaleia: 0, errosPinguim: 0);

int indexSP = 0;
PontuacaoSequencia primeiraPontuacaoSeq = PontuacaoSequencia(
    tempo: 0,
    tentativasEstagioUm: 0,
    tentativasEstagioDois: 0,
    tentativasEstagioTres: 0,
    tentativasEstagioQuatro: 0,
    errosTotais: 0);
int indexSUP = 0;
PontuacaoSequencia ultimaPontuacaoSeq = PontuacaoSequencia(
    tempo: 0,
    tentativasEstagioUm: 0,
    tentativasEstagioDois: 0,
    tentativasEstagioTres: 0,
    tentativasEstagioQuatro: 0,
    errosTotais: 0);
int indexSMP = 0;
PontuacaoSequencia melhorPontuacaoSeq = PontuacaoSequencia(
    tempo: 0,
    tentativasEstagioUm: 0,
    tentativasEstagioDois: 0,
    tentativasEstagioTres: 0,
    tentativasEstagioQuatro: 0,
    errosTotais: 0);

int indexSTPJ = 0;
PontuacaoStroop primeiraPontuacaoST = PontuacaoStroop(
    tempo: 0,
    acertos: 0,
    erros: 0,
    errosCorCongruentes: 0,
    errosCorNaoCongruentes: 0,
    pontuacao: 0);
int indexSTUJ = 0;
PontuacaoStroop ultimaPontuacaoST = PontuacaoStroop(
    tempo: 0,
    acertos: 0,
    erros: 0,
    errosCorCongruentes: 0,
    errosCorNaoCongruentes: 0,
    pontuacao: 0);
int indexSTMJ = 0;
PontuacaoStroop melhorPontuacaoST = PontuacaoStroop(
    tempo: 0,
    acertos: 0,
    erros: 0,
    errosCorCongruentes: 0,
    errosCorNaoCongruentes: 0,
    pontuacao: 0);

//pesquisa
class Pesquisa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: []),
      ),
    );
  }
}
