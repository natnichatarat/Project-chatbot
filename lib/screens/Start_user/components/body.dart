import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:project/chat_screen.dart';

//import 'package:flutter_swipe_button/flutter_swipe_button.dart';
//import 'package:project_application/components/rounded_button.dart';
//import 'package:project_application/constants.dart';
import 'package:project/screens/Start_user/components/background.dart';
import 'package:project/screens/auth/sign_in_screen.dart';

//import 'package:project_test/Screens/Welcome/welcome_screen.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
        child: Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            //color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 0.0,
                  vertical: 20.0), // กำหนด padding แนวนอน 20, แนวตั้ง 10
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignInScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.west),
                color: Colors.white,
                iconSize: 30.0,
              ),
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              /*Text(
                "Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'poppins',
                    color: Colors.white),
              )
                  .animate() // เพิ่มแอนิเมชันให้ข้อความ
                  .slideY(begin: 1.0, end: 0.0, duration: 800.ms),*/
              SizedBox(
                height: size.height * 0.1,
              ),
              Text(
                "มาเริ่มหาหอที่ใช่",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: 'NotoSansThai',
                    color: Colors.white),
              )
                  .animate() // เพิ่มแอนิเมชันให้ข้อความ
                  .slideY(begin: 1.0, end: 0.0, duration: 800.ms),
              Text(
                "ในสใตล์ของคุณกัน",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: 'NotoSansThai',
                    color: Colors.white),
              )
                  .animate() // เพิ่มแอนิเมชันให้ข้อความ
                  .slideY(begin: 1.0, end: 0.0, duration: 800.ms),
              SizedBox(
                height: size.height * 0.4,
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.6,
                  width: size.width * 0.4,
                ),
                Icon(
                  Icons.expand_less_sharp,
                  color: Colors.white,
                  size: 40,
                )
                    .animate()
                    .moveY(begin: 10, end: -10, duration: 800.ms)
                    .then()
                    .moveY(begin: -10, end: 10, duration: 800.ms),
                // ✅ ทำให้ลูกศรเด้งขึ้นลงเรื่อยๆ

                Spacer(),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'NotoSansThai',
                    ),
                  ).animate().slideY(
                      begin: 1.0,
                      end: 0.0,
                      duration: 800.ms), // ✅ ปิดวงเล็บให้ถูกต้อง
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

//ทำถึงตรงนี้