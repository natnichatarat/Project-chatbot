import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project/adddorm.dart';
import 'package:project/screens/Start_owner/components/background.dart';
import 'package:project/screens/auth/sign_in_screen.dart';

//import 'package:project_test/Screens/Welcome/welcome_screen.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    super.key,
    required this.child,
  });

  @override

  /// Build a screen for the start page of the app.
  ///
  /// This screen will show a background with a gradient color and a
  /// navigation icon at the top-left corner. The screen will also have a
  /// centered column with a text and a button. The text will be "Welcome"
  /// and the button will be "Start". When the button is pressed, the
  /// screen will navigate to the sign in screen.
  ///
  /// The screen will also have an animation that will move the navigation
  /// icon up and down. The animation will start when the screen is built
  /// and it will repeat indefinitely.
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
                " มาเริ่ม",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: 'NotoSansThai',
                    color: Colors.white),
              )
                  .animate() // เพิ่มแอนิเมชันให้ข้อความ
                  .slideY(begin: 1.0, end: 0.0, duration: 800.ms),
              Text(
                "เพิ่มหอพักของคุณ",
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
                        builder: (context) => AddDormScreen(),
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