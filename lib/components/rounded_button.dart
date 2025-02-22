import 'package:flutter/material.dart';
import 'package:project/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function? press;
  final Color color, textColor;
  final String fontFamily; // เพิ่มตัวแปรสำหรับฟอนต์

  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.fontFamily = 'Poppins',
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.6,
      child: ElevatedButton(
        onPressed: press as void Function()?,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          backgroundColor: color,
          side: const BorderSide(
            color: Color.fromARGB(100, 140, 28, 218), // สีของขอบ
            width: 2.5, // ความหนาของขอบ
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontFamily: fontFamily, // ใช้ฟอนต์ที่กำหนด
          ),
        ),
      ),
    );
  }
}
