import 'package:hive/hive.dart';

class BaseDeDatosUsuarios {
  final _usuariosBox = Hive.box('usuarios');

  void CrearDatosIniciales() {
    _usuariosBox.put('admin', {
      'contrasena': 'admin',
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

  // Método para registrar un nuevo usuario
  void registrarUsuario(
      String correoElectronico, String contrasena, String nombreCompleto) {
    _usuariosBox.put(correoElectronico,
        {'contrasena': contrasena, 'nombre_completo': nombreCompleto});
  }

  // Método para autenticar usuario
  bool autenticarUsuario(String correoElectronico, String contrasena) {
    var usuario = _usuariosBox.get(correoElectronico);
    return usuario != null && usuario['contrasena'] == contrasena;
  }

  //Método de manejo de sesión

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
      ["admin", "Hola a todos", "Hola, soy el administrador del foro"],
      ["admin", "Reglas", "Por favor, respetar las reglas del foro"],
    ];
    actualizarDatos();
  }

  void agregarPost(String nombre, String titulo, String texto) {
    listaPosts.add([nombre, titulo, texto]);
    actualizarDatos();
  }
}
