import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputFieldNum extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffixText;
  final String? Function(String?)? validator;

  const InputFieldNum({
    super.key,
    required this.controller,
    required this.hint,
    this.inputFormatters,
    this.suffixText,
    this.validator,
  });

  @override
  _InputFieldNumState createState() => _InputFieldNumState();
}

class _InputFieldNumState extends State<InputFieldNum> {
  bool _hasError = false;

  String _formatNumber(String value) {
    if (value.isEmpty) return value;
    final number = int.tryParse(value.replaceAll(',', ''));
    if (number == null) return value;
    return NumberFormat("#,###").format(number);
  }

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
              borderSide: BorderSide(color: Colors.red), // กรอบแดงเมื่อผิดพลาด
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  BorderSide(color: Colors.red), // กรอบแดงเมื่อโฟกัสและผิดพลาด
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            suffixText:
                widget.suffixText ?? (widget.hint.contains("") ? " บาท" : null),
            errorText: _hasError ? 'กรุณากรอกข้อมูล' : null,
            errorStyle: TextStyle(
              fontSize: 12, // ขนาดเล็กลง
              height: 0.4, // ลดระยะห่างระหว่างบรรทัด
              color: Colors.red,
            ),
          ),
          keyboardType: TextInputType.number,
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
            final newValue = _formatNumber(value);
            if (newValue != value) {
              widget.controller.value = TextEditingValue(
                text: newValue,
                selection: TextSelection.collapsed(offset: newValue.length),
              );
            }
            setState(() {
              _hasError = value.trim().isEmpty;
            });
          },
        ),
      ),
    );
  }
}
