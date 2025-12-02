import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String? label;
  final String? value;
  final ValueChanged<String>? onChange;
  final String type; // "text", "number", "email", "password"
  final String? placeholder;
  final bool multiline;

  const Input({
    Key? key,
    this.label,
    this.value,
    this.onChange,
    this.type = 'text',
    this.placeholder,
    this.multiline = false,
  }) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextInputType get _keyboardType {
    switch (widget.type) {
      case 'number':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }

  bool get _obscure => widget.type == 'password';

  @override
  Widget build(BuildContext context) {
    const fillColor = Color(0xFFF3F4F6); // gray-100
    const focusColor = Color(0xFF0B1E3B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 4),
            child: Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
          ),
        TextField(
          controller: _controller,
          keyboardType: _keyboardType,
          obscureText: _obscure,
          minLines: widget.multiline ? 4 : 1,
          maxLines: widget.multiline ? null : 1,
          onChanged: widget.onChange,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: focusColor, width: 2),
            ),
          ),
          style: TextStyle(color: Colors.grey[800]),
        ),
      ],
    );
  }
}