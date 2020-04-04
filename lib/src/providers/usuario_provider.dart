import 'dart:convert';

import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;


class UsuarioProvider{

  String _firebasetoken = 'AIzaSyApvT_TGUro2d8AVeK6ZMqY0L8_8i0Xjbs';
  final _prefs = new PreferenciasUsuario();



  Future<Map<String, dynamic>> login(String email, String password)async{

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final resp = await http.post(
     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebasetoken',
      
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      // Salvar el token en el Storage
      return{'Ok' : true, 'token' : decodedResp['idToken']};
    } else {
      return{'Ok' : false, 'mensaje' : decodedResp['error']['message']};
    }

  }

  Future<Map<String, dynamic>> nuevoUsuario(String email, String password)async{



    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$_firebasetoken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      // Salvar el token en el Storage
      return{'Ok' : true, 'token' : decodedResp['idToken']};
    } else {
      return{'Ok' : false, 'mensaje' : decodedResp['error']['message']};
    }
  }


}