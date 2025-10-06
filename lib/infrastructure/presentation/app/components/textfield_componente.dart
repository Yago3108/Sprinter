import 'package:flutter/material.dart';

class TextFieldComponente extends StatefulWidget {
  const TextFieldComponente({ super.key, this.controller, this.hint, this.label, this.error, this.isPassword = false });
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final String? error;
  final bool isPassword;

  @override
  State<TextFieldComponente> createState() => _TextFieldComponenteState();
}

class _TextFieldComponenteState extends State<TextFieldComponente> {
  late bool obsText;

  @override
  void initState() {
    super.initState();
    obsText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obsText,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        errorText: widget.error,
        suffixIcon: widget.isPassword
          ? IconButton(
            icon: Icon(
              obsText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                obsText = !obsText;
              });
            },
          )
          : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Lao Muang Don',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    );
  }
}