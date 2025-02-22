import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project/components/already_have_account_check.dart';
import 'package:project/components/rounded_button.dart';
import 'package:project/screens/Type/type_screen.dart';
import 'package:project/screens/Welcome/components/background.dart';
import 'package:project/screens/auth/sign_in_screen.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      key: const Key("backgroundkey"),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: -18,
            child: Image.asset(
              "assets/images/logo.png",
              height: size.height * 0.5,
            ).animate()
              ..fadeIn(
                  delay: 500.ms, duration: 800.ms), // แอนิเมชันให้โลโก้เด้ง
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.2),
                  Text(
                    "Welcome !",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      fontFamily: 'Poppins',
                    ),
                  )
                      .animate() // เพิ่มแอนิเมชันให้ข้อความ
                      .slideY(
                          begin: 1.0,
                          end: 0.0,
                          duration: 700.ms), // ขยายตัวเข้ามา
                  Text(
                    "to chatbot",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Poppins',
                    ),
                  ).animate().slideY(
                      begin: 1.0, end: 0.0, duration: 700.ms), // จางเข้ามา
                  SizedBox(height: 160),
                  RoundedButton(
                    text: "Log In",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SignInScreen();
                          },
                        ),
                      );
                    },
                    fontFamily: 'Poppins',
                  )
                      .animate() // เพิ่มแอนิเมชันให้ปุ่ม
                      .slideY(
                          begin: 1.0,
                          end: 0.0,
                          duration: 700.ms), // เลื่อนขึ้นจากล่าง
                  AlreadyHaveAccountCheck(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const TypeScreen(); // เปลี่ยนเป็นTpye SignUpScreen
                          },
                        ),
                      );
                    },
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 700.ms), // จางเข้ามาช้าๆ
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
