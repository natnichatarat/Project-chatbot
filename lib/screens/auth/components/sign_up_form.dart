import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/components/already_have_account_check.dart';
import 'package:project/components/rounded_button.dart';
import 'package:project/screens/Start_user/start_screen.dart';
import 'package:project/screens/Welcome/welcome_screen.dart';
import 'package:project/screens/auth/sign_in_screen.dart';

class SignUpForm extends StatefulWidget {
  final Widget? child;

  const SignUpForm({Key? key, this.child}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle sign up
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check if username already exists
        final usernameQuery = await _firestore
            .collection('users')
            .where('username', isEqualTo: _userNameController.text)
            .get();

        if (usernameQuery.docs.isNotEmpty) {
          throw FirebaseAuthException(
            code: 'username-already-in-use',
            message: 'Username already exists',
          );
        }

        // Create user with email and password
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          // Update user profile
          await userCredential.user!.updateDisplayName(
              "${_firstNameController.text} ${_lastNameController.text}");

          // Add user data to Firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'role': 'user',
            'email': _emailController.text.trim(),
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'username': _userNameController.text,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Navigate to start screen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StartScreen(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'weak-password':
            message = 'รหัสผ่านไม่ปลอดภัย กรุณาใช้รหัสผ่านที่ซับซ้อนกว่านี้';
            break;
          case 'email-already-in-use':
            message = 'มีบัญชีผู้ใช้นี้ในระบบแล้ว';
            break;
          case 'username-already-in-use':
            message = 'ชื่อผู้ใช้นี้ถูกใช้งานแล้ว';
            break;
          case 'invalid-email':
            message = 'อีเมลไม่ถูกต้อง';
            break;
          case 'operation-not-allowed':
            message = 'การลงทะเบียนด้วยอีเมลและรหัสผ่านไม่ได้เปิดใช้งาน';
            break;
          default:
            message = 'เกิดข้อผิดพลาด: ${e.message}';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height * 1.9,
            width: size.width * 1.9,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 20.0),
                        child: IconButton(
                          onPressed: !_isLoading
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WelcomeScreen(),
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.west),
                          color: Colors.white,
                          iconSize: 30.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Hello",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  enabled: !_isLoading,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "กรุณากรอกชื่อจริง"),
                                    MinLengthValidator(2,
                                        errorText:
                                            "ชื่อต้องมีความยาวอย่างน้อย 2 ตัวอักษร"),
                                    PatternValidator(r'^[a-zA-Z]+$',
                                        errorText: "เป็นตัวอักษรเท่านั้น")
                                  ]),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'First Name',
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  enabled: !_isLoading,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "กรุณากรอกนามกุล"),
                                    MinLengthValidator(2,
                                        errorText:
                                            "นามสกุลต้องมีความยาวอย่างน้อย 2 ตัวอักษร"),
                                    PatternValidator(r'^[a-zA-Z]+$',
                                        errorText: "เป็นตัวอักษรเท่านั้น")
                                  ]),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'Last Name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormField(
                          controller: _userNameController,
                          enabled: !_isLoading,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณากรอก Username"),
                            MinLengthValidator(4,
                                errorText: "ต้องมีความยาวอย่างน้อย 4 ตัวอักษร"),
                          ]),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'User Name',
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณากรอกอีเมล"),
                            EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                            PatternValidator(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                errorText:
                                    "กรุณากรอกอีเมลให้ถูกต้อง เช่น example@email.com"),
                          ]),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Email',
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: !_isPasswordVisible,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณากรอก Password"),
                            MinLengthValidator(8,
                                errorText:
                                    "Password ต้องมีความยาวอย่างน้อย 8 ตัวอักษร"),
                          ]),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: !_isLoading
                                  ? () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    }
                                  : null,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: "Password",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  const SizedBox(height: 30),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RoundedButton(
                          text: "Sign Up",
                          press: _signUp,
                        ),
                  const SizedBox(height: 10),
                  if (!_isLoading)
                    AlreadyHaveAccountCheck(
                      login: false,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
