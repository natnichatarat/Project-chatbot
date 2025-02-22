import 'package:flutter/material.dart';

class dropdownField extends StatelessWidget {
  const dropdownField({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  final String title;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6), // ลดระยะห่างด้านล่าง
      child: Container(
        height: 45, // ✅ กำหนดความสูงของ Dropdown
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(6), // ✅ ลดขนาดขอบมน
        ),
        child: DropdownButtonHideUnderline(
          // ✅ ซ่อนเส้นใต้ Dropdown
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(title,
                style: TextStyle(
                    fontSize: 14, color: Colors.black54)), // ✅ ลดขนาดตัวอักษร
            value: selectedValue,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style:
                        TextStyle(fontSize: 14)), // ✅ ลดขนาดตัวอักษรใน Dropdown
              );
            }).toList(),
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, size: 20), // ✅ ลดขนาดไอคอนลูกศร
          ),
        ),
      ),
    );
  }
}
