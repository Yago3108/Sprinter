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
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
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
        TextField(
            controller: widget.controller,
            obscureText: obsText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
              ),
              errorText: widget.error,
              errorStyle: const TextStyle(
                fontSize: 13,
                height: 0.8,
              ),
              prefixIcon: Icon(widget.prefixIcon, color: Color.fromARGB(255, 5, 106, 12)),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        obsText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Color.fromARGB(255, 5, 106, 12),
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
                      icon: Icon(Icons.clear),
                    )
                    : null,
              filled: true,
              fillColor: widget.error != null 
                  ? const Color(0xFFFFF5F5) 
                  : Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: widget.error != null 
                      ? Colors.red[300]! 
                      : Color.fromARGB(255, 5, 106, 12),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: widget.error != null 
                      ? Colors.red[400]! 
                      : Color.fromARGB(255, 5, 106, 12),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.red[400]!,
                  width: 1.5,
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