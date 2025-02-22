import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.inputFormatters,
    this.validator,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: SizedBox(
        height: 45,
        child: TextFormField(
          controller: widget.controller,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            errorText: _hasError ? 'กรุณากรอกข้อมูล' : null,
            errorStyle: TextStyle(
              fontSize: 12, // ขนาดเล็กลง
              height: 1, // ลดระยะห่างระหว่างบรรทัด
              color: Colors.red,
            ),
            errorMaxLines: 1, // จำกัดข้อความข้อผิดพลาดให้เป็นบรรทัดเดียว
          ),
          keyboardType: TextInputType.text,
          inputFormatters: widget.inputFormatters,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              setState(() {
                _hasError = true;
              });
              return 'กรุณากรอกข้อมูล';
            } else {
              setState(() {
                _hasError = false;
              });
            }
            return widget.validator?.call(value);
          },
          onChanged: (value) {
            setState(() {
              _hasError = value.trim().isEmpty;
            });
          },
        ),
      ),
    );
  }
}
