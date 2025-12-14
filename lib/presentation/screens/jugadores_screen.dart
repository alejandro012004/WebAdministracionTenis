import 'package:flutter/material.dart';
import 'package:practica_tenis_web/models/jugador_admin_model.dart';
import 'package:practica_tenis_web/services/jugador_service_admin.dart';

class JugadoresScreen extends StatefulWidget {
  const JugadoresScreen({super.key});

  @override
  State<JugadoresScreen> createState() => _JugadoresScreenState();
}

class _JugadoresScreenState extends State<JugadoresScreen> {
  final jugadorService = JugadorServiceAdmin();

  Future<void> _reloadJugadores() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = const Color.fromARGB(255, 88, 127, 255);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gestión de Jugadores'),
        centerTitle: true,
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<JugadorAdmin>>(
        future: jugadorService.getJugadores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar jugadores: ${snapshot.error.toString()}',
              ),
            );
          }
          final List<JugadorAdmin> jugadores = snapshot.data ?? [];

          if (jugadores.isEmpty) {
            return const Center(child: Text('No hay jugadores disponibles'));
          }

          return ListView.builder(
            itemCount: jugadores.length,
            itemBuilder: (context, index) {
              final jugador = jugadores[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(jugador.urlImagen),
                  ),
                  title: Text(
                    jugador.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${jugador.id} | Sets: ${jugador.sets}'),

                  onTap: () => _mostrarDialogoEdicion(context, jugador),

                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                    onPressed: () => _mostrarDialogoEdicion(context, jugador),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarDialogoEdicion(BuildContext context, JugadorAdmin jugador) {
    final TextEditingController nombreController = TextEditingController(
      text: jugador.nombre,
    );
    final TextEditingController urlController = TextEditingController(
      text: jugador.urlImagen,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Editar ${jugador.nombre}'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL de Imagen',
                      ),
                      keyboardType: TextInputType.url,
                      onChanged: (value) => setStateDialog(() {}),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () async {
                    jugador.nombre = nombreController.text.trim();
                    jugador.urlImagen = urlController.text.trim();

                    Navigator.of(context).pop();

                    bool success = await jugadorService.updateJugador(jugador);

                    if (success) {
                      await _reloadJugadores();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${jugador.nombre} actualizado correctamente.',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Error al guardar los cambios en el servidor.',
                          ),
                        ),
                      );
                      await _reloadJugadores();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
