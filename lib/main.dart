import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:project/DormDetail.dart';
import 'package:project/adddorm.dart';
import 'package:project/constants.dart';
import 'package:project/screens/welcome/welcome_screen.dart';
import 'package:project/screens/auth/sign_in_screen.dart';
import 'package:project/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.deviceCheck,
  );

  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// กลไกป้องกันการเรียก Firebase App Check Token ซ้ำ
String? _lastToken;
DateTime? _lastRequestTime;

Future<String?> getFirebaseAppCheckToken() async {
  if (_lastRequestTime != null &&
      DateTime.now().difference(_lastRequestTime!) < Duration(minutes: 5)) {
    return _lastToken; // ใช้ Token เดิมหากยังไม่หมดอายุ
  }

  try {
    _lastToken = await FirebaseAppCheck.instance.getToken();
    _lastRequestTime = DateTime.now();
    return _lastToken;
  } catch (e) {
    print('Error getting App Check token: $e');
    return null;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Welcome',
      theme: ThemeData(
        fontFamily: "poppins,NotoSansThai",
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/sign-in': (context) => SignInScreen(),
        '/chat': (context) => ChatScreen(),
        '/add-dorm': (context) => AddDormScreen(),
        '/dorm-detail': (context) => DormDetail(),
      },
    );
  }
}
