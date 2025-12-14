import 'dart:convert';

List<JugadorAdmin> jugadoresAdminFromJson(String str) {
  final Map<String, dynamic> jsonResponse = json.decode(str);

  final List<dynamic>? jugadoresList = jsonResponse['data'] as List<dynamic>?;

  if (jugadoresList == null) return [];

  return List<JugadorAdmin>.from(
    jugadoresList.map((x) => JugadorAdmin.fromJson(x)),
  );
}

class JugadorAdmin {
  final String id;
  String nombre;
  String urlImagen;
  final List<int> juegos;
  final int puntos;
  final int sets;

  JugadorAdmin({
    required this.id,
    required this.nombre,
    required this.urlImagen,
    required this.juegos,
    required this.puntos,
    required this.sets,
  });

  factory JugadorAdmin.fromJson(Map<String, dynamic> json) => JugadorAdmin(
    id: json["id"] as String,
    nombre: json["nombre"] as String,
    urlImagen: json["urlImagen"] as String,
    juegos: List<int>.from(json["juegos"].map((x) => x)),
    puntos: json["puntos"] as int,
    sets: json["sets"] as int,
  );

  Map<String, dynamic> toJson() => {"nombre": nombre, "urlImagen": urlImagen};
}
