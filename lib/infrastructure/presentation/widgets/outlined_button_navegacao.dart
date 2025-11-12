import 'package:flutter/material.dart';

class OutlinedButtonNavegacao extends StatelessWidget {
  const OutlinedButtonNavegacao({ super.key, required this.function, required this.text1, required this.text2 });
  final VoidCallback function;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => function(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(
          color: Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text1,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
              fontFamily: 'Lao Muang Don',
            ),
          ),
          Text(
            text2,
            style: TextStyle(
              color: Color.fromARGB(1000, 5, 106, 12),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lao Muang Don',
            ),
          ),
        ],
      ),
    );
  }
}