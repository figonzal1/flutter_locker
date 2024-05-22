import 'package:flutter/material.dart';

class MiVista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Vista'),
      ),
      body: Center(
        child: Text('¡Hola, mundo!'),
      ),
    );
  }
}
