import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:practica_flutter/datos/db.dart';
import 'package:practica_flutter/widgets/ForoPosts.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final _usuariosBox = Hive.box('usuarios');
  final _BoxPosts = Hive.box('foro_posts');

  BaseDeDatosUsuarios baseDeDatosUsuarios = BaseDeDatosUsuarios();
  BaseDeDatosPosts baseDeDatosPosts = BaseDeDatosPosts();

  TextEditingController textopost = TextEditingController();
  TextEditingController titulopost = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_usuariosBox.isEmpty) {
      baseDeDatosUsuarios.CrearDatosIniciales();
    }
    if (_BoxPosts.isEmpty) {
      baseDeDatosPosts.CrearDatosIniciales();
    } else {
      baseDeDatosPosts.cargarDatos();
      print(baseDeDatosPosts.listaPosts.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro de discusión'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Bienvenido al foro',
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nombre',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: titulopost,
                          readOnly: !baseDeDatosUsuarios.estadoSesion(),
                          decoration: const InputDecoration(
                            hintText:
                                'Escribe aquí el título de tu publicación',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: textopost,
                          readOnly: !baseDeDatosUsuarios.estadoSesion(),
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Escribe aquí tu publicación',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              baseDeDatosPosts.agregarPost(
                                  _usuariosBox.get('sesion_mail'),
                                  titulopost.text,
                                  textopost.text);

                                  titulopost.clear();
                                  textopost.clear();
                            });
                          },
                          child: const Text('Crear publicación'),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: SingleChildScrollView(
                          child: Column(
                            children: baseDeDatosPosts.listaPosts.map((post) {
                              return ForoPosts(
                                nombre: post[0],
                                titulo: post[1],
                                textopost: post[2],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Visibility(
                    visible: baseDeDatosUsuarios.estadoSesion(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre: ${baseDeDatosUsuarios.cargarUsuario(_usuariosBox.get('sesion_mail'))?['nombre_completo']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Email: ${_usuariosBox.get('sesion_mail')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !baseDeDatosUsuarios.estadoSesion(),
              child: ListTile(
                title: const Text('Iniciar Sesión'),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/iniciarSesion");
                },
              ),
            ),
            Visibility(
              visible: !baseDeDatosUsuarios.estadoSesion(),
              child: ListTile(
                title: const Text('Registrar'),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/registro");
                },
              ),
            ),
            Visibility(
              visible: baseDeDatosUsuarios.estadoSesion(),
              child: ListTile(
                title: const Text('Cerrar Sesión'),
                onTap: () {
                  baseDeDatosUsuarios.cerrarSesion();
                  Navigator.popAndPushNamed(context, "/principal");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
