import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  Icon icono;
  String label;
  TextEditingController controller = TextEditingController();
  bool obscure;

  InputText({super.key, required this.icono, required this.label, required this.controller, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: icono
      ),
      obscureText: obscure,
    );
  }
}
