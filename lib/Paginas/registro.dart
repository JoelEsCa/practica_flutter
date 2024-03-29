import 'package:flutter/material.dart';
import 'package:practica_flutter/widgets/InputText.dart';
import 'package:practica_flutter/datos/db.dart';

class Registro extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  BaseDeDatosUsuarios baseDeDatosUsuarios = BaseDeDatosUsuarios();

  Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro',
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputText(
                icono: const Icon(Icons.person),
                label: "Nombre completo",
                controller: nameController,
              ),
              const SizedBox(height: 16.0),
              InputText(
                icono: const Icon(Icons.email),
                label: "Correo electrónico",
                controller: emailController,
              ),
              const SizedBox(height: 16.0),
              InputText(
                icono: const Icon(Icons.lock),
                label: "Contraseña",
                controller: passwordController,
                obscure: true,
              ),
              const SizedBox(height: 16.0),
              InputText(
                icono: const Icon(Icons.lock),
                label: "Confirmar contraseña",
                controller: confirmPasswordController,
                obscure: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  if (baseDeDatosUsuarios.existeUsuario(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                            label: 'Iniciar Sesión',
                            onPressed: () =>
                                Navigator.pushNamed(context, "/iniciarSesion")),
                        content: const Text(
                            'El correo electrónico ya está registrado'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  } else {
                    if (emailController.text.toLowerCase().contains("admin")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'El correo electrónico no puede contener la palabra "admin"'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    } else {
                      if (baseDeDatosUsuarios.registrarUsuario(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          confirmPasswordController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Registro exitoso. Redirigiendo a página principal...'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/principal');
                      } else {
                        passwordController.clear();
                        confirmPasswordController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Las contraseñas no coinciden. Intente de nuevo.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Registrarse',
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
