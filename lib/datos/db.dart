import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

class BaseDeDatosUsuarios {
  final _usuariosBox = Hive.box('usuarios');

  void CrearDatosIniciales() {
    _usuariosBox.put('admin', {
      'contrasena': sha256.convert(utf8.encode('admin')).toString(),
      'nombre_completo': 'Administrador'
    }); // Creamos el usuario administrador
    _usuariosBox.put('sesion_loged',
        false); // Guardamos estado de sesión (true = logeado, false = no logeado)
    _usuariosBox.put('sesion_mail',
        ''); // Inicializamos el usuario nombre del usuario logeado
  }

  // Método para cargar datos de usuario por su correo electrónico
  Map<dynamic, dynamic>? cargarUsuario(String correoElectronico) {
    return _usuariosBox.get(correoElectronico);
  }

  //Metodo para saber si existe un usuario
  bool existeUsuario(String correoElectronico) {
    return _usuariosBox.containsKey(correoElectronico);
  }

  // Método para obtener el estado de la sesión
  bool estadoSesion() {
    return _usuariosBox.get('sesion_loged');
  }

  bool esAdmin() {
    bool x = false;
    if (estadoSesion()) {
      if (_usuariosBox.get('sesion_mail') == "admin") {
        x = true;
      }
    }
    return x;
  }

  // Método para registrar un nuevo usuario
  bool registrarUsuario(String correoElectronico, String contrasena,
      String nombreCompleto, String verificarContrasena) {
    bool x = false;

    if (contrasena == verificarContrasena) {
      _usuariosBox.put(correoElectronico, {
        'contrasena': sha256.convert(utf8.encode(contrasena)).toString(),
        'nombre_completo': nombreCompleto
      });
      x = true;
    }
    return x;
  }

  // Método para autenticar usuario
  bool autenticarUsuario(String correoElectronico, String contrasena) {
    var usuario = _usuariosBox.get(correoElectronico);
    print(contrasena);
    return usuario != null && usuario['contrasena'] == contrasena;
  }

  //Métodos de manejo de sesión
  void iniciarSesion(String mail) {
    _usuariosBox.put('sesion_loged', true);
    _usuariosBox.put('sesion_mail', mail);
  }

  void cerrarSesion() {
    _usuariosBox.put('sesion_loged', false);
    _usuariosBox.put('sesion_mail', '');
  }
}

class BaseDeDatosPosts {
  List listaPosts = [];

  final _BoxPosts = Hive.box('foro_posts');

  void cargarDatos() {
    listaPosts = _BoxPosts.get('foro_posts');
  }

  void actualizarDatos() {
    _BoxPosts.put('foro_posts', listaPosts);
  }

  void CrearDatosIniciales() {
    listaPosts = [
      [
        "Administrador",
        "Hola a todos",
        "Hola, soy el administrador del foro",
        "1 de enero de 2024"
      ],
      [
        "Administrador",
        "Reglas",
        "Por favor, respetar las reglas del foro",
        "1 de enero de 2024"
      ],
    ];
    actualizarDatos();
  }

  void agregarPost(String nombre, String titulo, String texto) {
    //Sacamos la fecha del momento
    DateTime now = DateTime.now();

    //Hacemos una lista con los meses para transformar el número al nombre del mes correspondiente
    List<String> months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];

    String fecha =
        '${now.day.toString()} de ${months[now.month - 1]} de ${now.year.toString()}';

    listaPosts.add([nombre, titulo, texto, fecha]);

    actualizarDatos();
  }
}
