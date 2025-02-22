import 'package:flutter/material.dart';
import 'package:project/components/text_field_containner.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      obscureText: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        suffixIcon: Icon(Icons.visibility),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text("Passwords"),
      ),
    ));
  }
}
