import 'package:hive/hive.dart';

class BaseDeDatosUsuarios {
  final _usuariosBox = Hive.box('usuarios');

  void CrearDatosIniciales() {
    _usuariosBox.put('admin', {'contrasena': 'admin'});
  }

  // Método para cargar datos de usuario por su correo electrónico
  Map<String, dynamic>? cargarUsuario(String correoElectronico) {
    return _usuariosBox.get(correoElectronico);
  }

  // Método para registrar un nuevo usuario
  void registrarUsuario(String correoElectronico, String contrasena) {
    _usuariosBox.put(correoElectronico, {'contrasena': contrasena});
  }

  // Método para autenticar usuario
  bool autenticarUsuario(String correoElectronico, String contrasena) {
    var usuario = _usuariosBox.get(correoElectronico);
    return usuario != null && usuario['contrasena'] == contrasena;
  }
}
