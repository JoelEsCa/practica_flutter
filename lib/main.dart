import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:practica_flutter/Paginas/iniciar_sesion.dart';
import 'package:practica_flutter/Paginas/principal.dart';
import 'package:practica_flutter/Paginas/registro.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('usuarios');

  runApp(const Init());
}

class Init extends StatelessWidget {
  const Init({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaPrincipal(),
      routes: {
        '/principal': (context) => const PaginaPrincipal(),
        '/iniciarSesion': (context) =>  IniciarSesion(),
        '/registro': (context) => Registro(),
      }
    );
  }
}