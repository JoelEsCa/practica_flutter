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
  String nombre_completo_usuario_sesion = '';

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

    if (baseDeDatosUsuarios.estadoSesion()) {
      nombre_completo_usuario_sesion = baseDeDatosUsuarios
          .cargarUsuario(_usuariosBox.get('sesion_mail'))?['nombre_completo'];
    } else {
      nombre_completo_usuario_sesion = "No logeado";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foro de discusión',
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Stack(
          children: [
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          nombre_completo_usuario_sesion,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          child: TextField(
                            controller: titulopost,
                            readOnly: !baseDeDatosUsuarios.estadoSesion(),
                            decoration: const InputDecoration(
                              hintText:
                                  'Escribe aquí el título de tu publicación.',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100,
                          child: TextField(
                            controller: textopost,
                            readOnly: !baseDeDatosUsuarios.estadoSesion(),
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              hintText: 'Escribe aquí tu publicación.',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (baseDeDatosUsuarios.estadoSesion()) {
                              if (titulopost.text.isNotEmpty &&
                                  textopost.text.isNotEmpty) {
                                if (titulopost.text.length > 35) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('El título es demasiado largo.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    baseDeDatosPosts.agregarPost(
                                        nombre_completo_usuario_sesion,
                                        titulopost.text,
                                        textopost.text);

                                    titulopost.clear();
                                    textopost.clear();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Publicación creada correctamente.'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Niguno de los dos campos pueden estar vacíos.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Solo puedes crear publicaciones estando logeado.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text('Crear publicación'),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: SingleChildScrollView(
                          child: Column(
                              children: baseDeDatosPosts.listaPosts
                                  .asMap() //Convertimos la lista en un mapa
                                  .entries // Sacamos las claves
                                  .map((entry) {
                            //Mapeamos
                            final post = entry.value;

                            print('Inicializando post');
                            print('titulo: ${post[1]}');
                            print('Indice: ${entry.key}');
                            print('es admin: ${baseDeDatosUsuarios.esAdmin()}');

                            return ForoPosts(
                              nombre: post[0],
                              titulo: post[1],
                              textopost: post[2],
                              fecha: post[3],
                              admin: baseDeDatosUsuarios.esAdmin(),
                              funcion_borrar: () {
                                setState(() {
                                  baseDeDatosPosts.listaPosts
                                      .removeAt(entry.key);
                                  baseDeDatosPosts.actualizarDatos();
                                });
                              },
                            );
                          }).toList() //Los convertimos en una lista y se vean correctamente por pantalla,
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
                          'Nombre: $nombre_completo_usuario_sesion',
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
