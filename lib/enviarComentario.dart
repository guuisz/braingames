import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'usuarios.dart';

class Comentario {
  late String comentario;

  Comentario({
    required this.comentario,
  });

  Map<String, dynamic> toMap() {
    return {
      'comentario': comentario,
    };
  }

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      comentario: map['comentario'],
    );
  }
}

Comentario comentario = new Comentario(comentario: '');

Future<int> geraNum(Usuario user) async {
  int numero = 0;
  List<Comentario> comentarios;

  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/comentarios/${user.usuario}/.json";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data is List) {
        for (dynamic item in data) {
          print('oi');
          numero += 1;
        }
      } else if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          print('oi');
          numero += 1;
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
  
  return numero;
}

Future<void> enviarComentario(Usuario user,Comentario comentario) async {
  int numero = await geraNum(usuario) ;

  var url =
      "https://it-project-22ec0-default-rtdb.firebaseio.com/comentarios/${user.usuario}/comentario-${numero}.json";

  try {
    await http.put(
      Uri.parse(url),
      body: json.encode(comentario.toMap()),
    );
  } catch (error) {
    print(error);
  }
}

class OiPage extends StatefulWidget {
  @override
  _OiPageState createState() => _OiPageState();
}

final TextEditingController _textComment =
    TextEditingController();
String _savedEmail = "";

class _OiPageState extends State<OiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "Enviar Comentários",
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
            Center(
              child: Container(
                  width: 400,
                  height: 470,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 40)),
                      Center(
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.0),
                          ),
                          child: TextField(
                            controller: _textComment,
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Digite algo',
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 30)),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              comentario.comentario = _textComment.text;
                              enviarComentario(usuario, comentario);
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(36, 255, 0, 100),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                "Enviar Comentário",
                                style: TextStyle(
                                    fontSize: 24, fontFamily: "Inter"),
                              )),
                            ),
                          ),
                        ],
                      ))
                    ],
                  )),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TelaDeSelecao()));
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
      ],
    ));
  }
}
