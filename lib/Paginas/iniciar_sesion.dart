import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:practica_flutter/datos/db.dart';
import 'package:practica_flutter/widgets/InputText.dart';

class IniciarSesion extends StatefulWidget {
  IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _usuariosBox = Hive.box('usuarios');

  BaseDeDatosUsuarios baseDeDatosUsuarios = BaseDeDatosUsuarios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar sesión',
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Container(
          width: 300, // Ancho del contenedor en píxeles
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputText(
                icono: const Icon(Icons.email),
                label: "Correo Electrónico",
                controller: emailController,
              ),
              const SizedBox(height: 16.0),
              InputText(
                icono: const Icon(Icons.lock),
                label: "Contraseña",
                controller: passwordController,
                obscure: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  bool inicio = baseDeDatosUsuarios.autenticarUsuario(
                      emailController.text, sha256.convert(utf8.encode(passwordController.text.trim())).toString());
                  if (inicio) {
                    baseDeDatosUsuarios.iniciarSesion(emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Inició sesión exitoso. Redirigiendo...'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pushNamed(context, '/principal');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Correo electrónico o contraseña incorrectos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
