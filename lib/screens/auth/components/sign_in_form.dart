import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/adddorm.dart';
import 'package:project/chat_screen.dart';
import 'package:project/components/already_have_account_check.dart';
import 'package:project/screens/Type/type_screen.dart';
import 'package:project/screens/admin/admin_dashboard.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        // เปลี่ยนจากเดิมตรงนี้
        if (emailController.text.trim() == "opalnatni@gmail.com" &&
            passwordController.text == "admin1234") {
          // ล็อกอินด้วย Firebase Auth ก่อน
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          // สร้างหรืออัปเดตเอกสารผู้ใช้แอดมิน
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': 'opalnatni@gmail.com',
            'role': 'admin',
            'username': 'Admin Opal',
            'createdAt': FieldValue.serverTimestamp(),
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
          return;
        }

        // ถ้าไม่ใช่ admin ให้ล็อกอินปกติ
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // ถ้าไม่ใช่ admin ให้ตรวจสอบ role ตามปกติ
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          String userRole = userDoc.get('role');

          if (userRole == 'owner') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AddDormScreen()),
            );
          } else if (userRole == 'user') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          }
          if (emailController.text.trim() == "opalnatni@gmail.com" &&
              passwordController.text == "admin1234") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
            return;
          }
        } else {
          _showErrorDialog('ไม่พบข้อมูลผู้ใช้');
        }
      } catch (e) {
        _showErrorDialog('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.3,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(29),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Your Email",
                icon: Icon(Icons.person, color: Colors.deepPurple),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(29),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(Icons.lock, color: Colors.deepPurple),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                child: Text(
                  "SIGN IN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          AlreadyHaveAccountCheck(
            login: true,
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const TypeScreen();
              }));
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
