import 'package:flutter/material.dart';
import 'package:practica_flutter/datos/db.dart';

class ForoPosts extends StatelessWidget {
  final String nombre;
  final String titulo;
  final String textopost;
  final String fecha;
  final bool admin;
  final void Function()? funcionBorrar;

  ForoPosts(
      {Key? key,
      required this.nombre,
      required this.titulo,
      required this.textopost,
      required this.fecha,
      required this.admin,
      required this.funcionBorrar})
      : super(key: key);

  BaseDeDatosPosts baseDeDatosPosts = BaseDeDatosPosts();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.amber[400],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nombre,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                titulo,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textopost,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: admin,
                  child: ElevatedButton(
                    onPressed: funcionBorrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                Text(
                  'Publicado el $fecha',
                  style: const TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 100, 99, 99)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
