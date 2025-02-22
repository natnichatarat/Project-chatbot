import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordnewController = TextEditingController();
  final TextEditingController _passwordoldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String userId = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        _firstNameController.text = userData['firstName'] ?? '';
        _lastNameController.text = userData['lastName'] ?? '';
        _userNameController.text = userData['username'] ?? '';
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e'),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // แสดง Dialog ยืนยันการบันทึก
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('คุณต้องการบันทึกข้อมูลหรือไม่?'),
            actions: <Widget>[
              TextButton(
                child: Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('ตกลง'),
                onPressed: () async {
                  Navigator.of(context).pop(); // ปิด Dialog
                  await _performUpdate(); // แยกฟังก์ชันการอัพเดทข้อมูล
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _performUpdate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = _auth.currentUser;

      if (_passwordoldController.text.isNotEmpty &&
          _passwordnewController.text.isNotEmpty) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: currentUser!.email!, password: _passwordoldController.text);

        await currentUser.reauthenticateWithCredential(credential);
        await currentUser.updatePassword(_passwordnewController.text);
      }

      String userId = currentUser!.uid;

      var usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: _userNameController.text)
          .where(FieldPath.documentId, isNotEqualTo: userId)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        throw Exception('ชื่อผู้ใช้นี้ถูกใช้งานแล้ว');
      }

      await _firestore.collection('users').doc(userId).update({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'username': _userNameController.text,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      await currentUser.updateDisplayName(
          "${_firstNameController.text} ${_lastNameController.text}");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('บันทึกข้อมูลสำเร็จ'),
            actions: <Widget>[
              TextButton(
                child: Text('ตกลง'),
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด Dialog
                  Navigator.pop(context); // กลับไปหน้าก่อนหน้า
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      String errorMessage = 'เกิดข้อผิดพลาด: ';
      if (e.toString().contains('wrong-password')) {
        errorMessage += 'รหัสผ่านเก่าไม่ถูกต้อง';
      } else {
        errorMessage += e.toString();
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text(errorMessage),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขโปรไฟล์',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3C1A80),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
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
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "กรุณากรอกนามสกุล"),
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
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _userNameController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "กรุณากรอก Username"),
                          MinLengthValidator(4,
                              errorText: "ต้องมีความยาวอย่างน้อย 4 ตัวอักษร"),
                          PatternValidator(r'^[a-zA-Z0-9_]+$',
                              errorText:
                                  "Username ต้องประกอบด้วยตัวอักษร ตัวเลข หรือ _ เท่านั้น")
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'User Name',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordoldController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'รหัสผ่านเก่า',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordnewController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'รหัสผ่านใหม่',
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3C1A80),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 40),
                            ),
                            child: Text(
                              "บันทึกการเปลี่ยนแปลง",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _passwordoldController.dispose();
    _passwordnewController.dispose();
    super.dispose();
  }
}
