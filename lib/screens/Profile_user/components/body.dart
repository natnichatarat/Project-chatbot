import 'package:flutter/material.dart';
import 'package:project/screens/Profile_user/components/background.dart';
import 'package:project/screens/Welcome/welcome_screen.dart';

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
        key: const Key("backgroundkey"),
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: -8,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomeScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.west),
                color: Colors.black,
                iconSize: 30.0,
              ),
            ),
            Positioned(
              top: 0,
              left: -38,
              child: Container(
                color: Colors.green,
                width: 350, // กำหนดความกว้างของ Container
                height: 800,
                margin: const EdgeInsets.all(55.0),
                padding: const EdgeInsets.all(0.0), // กำหนดความสูงของ Container
                child: Column(children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    // color: Colors.black,
                    width: 150,
                    child: const CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          ExactAssetImage('assets/images/profile.png'),
                    ),
                    /*(decoration: BoxDecoration(
                        shape: BoxShape.circle, 
                        
                        ),*/
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: Row(
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: Row(
                      children: [
                        Text('ID',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ))
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ));
  }
}

//ทำถึงตรงนี้