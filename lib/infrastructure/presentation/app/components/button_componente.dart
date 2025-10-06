import 'package:flutter/material.dart';

class ButtonComponente extends StatelessWidget {
  const ButtonComponente({ super.key, required this.text, required this.function });
  final String text;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 60),
        backgroundColor: Color.fromARGB(1000, 5, 106, 12),
      ), 
      child: Text(text, style: 
        TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Lao Muang Don',
        ),
      ),
    );
  }
}