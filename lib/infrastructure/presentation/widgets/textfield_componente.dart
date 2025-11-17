import 'package:flutter/material.dart';

class TextFieldComponente extends StatefulWidget {
  const TextFieldComponente({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.hint,
    required this.label,
    this.error,
    this.isPassword = false,
  });
  
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hint;
  final String label;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Lao Muang Don',
            ),
          ),
        ),

        const SizedBox(height: 10),
        
        // Text Field
        TextField(
          controller: widget.controller,
          obscureText: obsText,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            errorText: widget.error,
            prefixIcon: Icon(widget.prefixIcon, color: widget.error == null ? Color.fromARGB(255, 5, 106, 12) : Colors.red[400]),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      obsText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: widget.error == null ? Color.fromARGB(255, 5, 106, 12) : Colors.red[400],
                    ),
                    onPressed: () {
                      setState(() {
                        obsText = !obsText;
                      });
                    },
                  )
                : widget.controller.text.isNotEmpty 
                  ? IconButton(
                    onPressed: () => widget.controller.clear(), 
                    icon: Icon(Icons.clear, color: widget.error == null ? Color.fromARGB(255, 5, 106, 12) : Colors.red[400]),
                  )
                  : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 5, 106, 12),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 5, 106, 12),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.red[400]!,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.red[400]!,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}