import 'package:flutter/material.dart';

void showLogoutConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title:
            const Text(
              "Confirmação de Logout",
              style: TextStyle(
                color: Color.fromARGB(255, 5, 106, 12),
                fontWeight: FontWeight.bold,
              ),
            ),
        content: const Text("Tem certeza de que deseja sair da sua conta?"),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "Cancelar",
              style: TextStyle(
                color: Color.fromARGB(255, 5, 106, 12)
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 5, 106, 12),
            ),
            child: const Text(
              "Sair",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}
