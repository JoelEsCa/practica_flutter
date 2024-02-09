import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:practica_flutter/datos/db.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final _usuariosBox = Hive.box('usuarios');

  BaseDeDatosUsuarios baseDeDatosUsuarios = BaseDeDatosUsuarios();

  @override
  void initState() {
    super.initState();
    if (_usuariosBox.isEmpty) {
      baseDeDatosUsuarios.CrearDatosIniciales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro de discusión'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido a la página principal',
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader( //menu hamburgesa
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú Hamburguesa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Iniciar Sesión'),
              onTap: () {
                // Acciones al hacer clic en la opción 1
                Navigator.popAndPushNamed(context, "/iniciarSesion");
              },
            ),
            ListTile(
              title: const Text('Registrar'),
              onTap: () {
                // Acciones al hacer clic en la opción 2
                Navigator.popAndPushNamed(context, "/registro");
              },
            ),
            // Puedes agregar más opciones según tus necesidades
          ],
        ),
      ),
    );
  }
}
