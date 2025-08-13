import 'package:flutter/material.dart';

class PaginaAmizades extends StatelessWidget {
  const PaginaAmizades({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 5, 106, 12),
          title: Text("Amizades",style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
      ),
    );
  }
}