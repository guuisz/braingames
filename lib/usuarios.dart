import 'package:http/http.dart' as http;import 'dart:convert';

class Usuario {
  late String nome;
  late String usuario;
  late String email;
  late String senha;
  late String dataDeNascimento;
  late String genero;
  late String pontuacao;

  // Construtor
  Usuario({
    required this.nome,
    required this.usuario,
    required this.email,
    required this.senha,
    required this.dataDeNascimento,
    required this.genero,
  });

    Usuario.vazio({
      this.nome = '',
      this.usuario = '',
      this.email = '',
      this.senha = '',
      this.dataDeNascimento = '',
      this.genero = '',
    });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'usuario' : usuario,
      'email': email,
      'senha': senha,
      'dataDeNascimento' : dataDeNascimento,
      'genero' : genero,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      nome: map['nome'],
      usuario: map['usuario'],
      email: map['email'],
      senha: map['senha'],
      dataDeNascimento: map['dataDeNascimento'],
      genero: map['genero'],
    );
  }
}

Future<bool> enviarUsuarioParaOFireBase(Usuario user) async {

  List<Usuario> usuariosCadastrados = await recuperarTodosOsUsuarios();
  bool realizaCadastro = true;

  for(Usuario atualRegistro in usuariosCadastrados) {
    if(user.email == atualRegistro.email || user.usuario == atualRegistro.usuario) {
      realizaCadastro = false;
    }
  }
  
  if(realizaCadastro) {
  var url = "https://it-project-22ec0-default-rtdb.firebaseio.com/usuarios/${user.usuario}.json";
  try {
    
    await http.put(
      Uri.parse(url),
      body: json.encode(user.toMap()),
    );
  } catch (error) {
    print (error);
  }
  }
  return realizaCadastro;
}

Future<Usuario> editarPerfil(Usuario antigoUser , Usuario novoUser) async {
  
  var removeUrl = "https://it-project-22ec0-default-rtdb.firebaseio.com/usuarios/${antigoUser.usuario}.json";
  var addUrl = "https://it-project-22ec0-default-rtdb.firebaseio.com/usuarios/${novoUser.usuario}.json";

  try {
    
    await http.delete(
     Uri.parse(removeUrl),
    );
    
    await http.put(
      Uri.parse(addUrl),
      body: json.encode(novoUser.toMap()),
    );
  } catch (error) {
    print (error);
  }

  return novoUser;

}

Future<List<Usuario>> recuperarTodosOsUsuarios() async {
  List<Usuario> usuariosCadastrados = [];
  var url = "https://it-project-22ec0-default-rtdb.firebaseio.com/usuarios.json";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? dados = json.decode(response.body);

      if (dados != null) {
        dados.forEach((key, value) {
          usuariosCadastrados.add(Usuario.fromMap(value));
        });
      }
    } else {
      // Tratar aqui o caso em que a requisição não foi bem-sucedida
      print("Erro na requisição: ${response.statusCode}");
    }

  } catch (error) {
    print(error);
  }

  return usuariosCadastrados;
}

Future<Usuario> realizaLogin(String usuarioDigitado, String senhaDigitada) async {
  List<Usuario> usuariosCadastrados = await recuperarTodosOsUsuarios();

  for(Usuario usuario in usuariosCadastrados) {
    if(usuario.usuario == usuarioDigitado) {
      if(usuario.senha == senhaDigitada) {
        return usuario;
      }
    }
  }

  return Usuario.vazio();

}