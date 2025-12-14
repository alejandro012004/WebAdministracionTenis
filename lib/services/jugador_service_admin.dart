import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practica_tenis_web/models/jugador_admin_model.dart';

class JugadorServiceAdmin {
  final String _baseUrl =
      'https://backendpotenis.onrender.com/api/v1/tenis/admin/jugadores';

  Future<List<JugadorAdmin>> getJugadores() async {
    try {
      Uri uri = Uri.parse(_baseUrl);
      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        return jugadoresAdminFromJson(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateJugador(JugadorAdmin jugador) async {
    if (jugador.id.isEmpty) {
      return false;
    }

    try {
      String updateUrl = '$_baseUrl/${jugador.id}';
      Uri uri = Uri.parse(updateUrl);

      http.Response response = await http.patch(
        uri,
        body: jsonEncode(jugador.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
