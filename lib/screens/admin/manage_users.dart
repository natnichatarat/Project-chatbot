import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _editUser(String userId, Map<String, dynamic> userData) {
    TextEditingController usernameController =
        TextEditingController(text: userData['username'] ?? '');
    TextEditingController passwordController =
        TextEditingController(text: userData['password'] ?? '');
    TextEditingController firstnameController =
        TextEditingController(text: userData['firstname'] ?? '');
    TextEditingController lastnameController =
        TextEditingController(text: userData['lastname'] ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("แก้ไขข้อมูลผู้ใช้"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "ชื่อผู้ใช้"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "รหัสผ่าน"),
              ),
              TextField(
                controller: firstnameController,
                decoration: InputDecoration(labelText: "ชื่อ"),
              ),
              TextField(
                controller: lastnameController,
                decoration: InputDecoration(labelText: "นามสกุล"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ยกเลิก"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // อัพเดทข้อมูลใน Firestore
                  await _firestore.collection('users').doc(userId).update({
                    'username': usernameController.text,
                    'password': passwordController.text,
                    'firstname': firstnameController.text,
                    'lastname': lastnameController.text,
                    'lastUpdated': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('อัพเดทข้อมูลสำเร็จ')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                  );
                }
              },
              child: Text("บันทึก"),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(String userId, String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณแน่ใจหรือไม่ว่าต้องการลบ $username ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ยกเลิก"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // ลบข้อมูลจาก Firestore
                  await _firestore.collection('users').doc(userId).delete();

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ลบข้อมูลสำเร็จ')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                  );
                }
              },
              child: Text("ลบ", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _isAdmin() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("ไม่พบผู้ใช้ที่ล็อกอิน");
      return false;
    }

    try {
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();

      return userData != null &&
          (userData['role'] == 'admin' ||
              userData['email'] == 'opalnatni@gmail.com');
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการผู้ใช้',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'poppins'),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "ไม่มีข้อมูลผู้ใช้",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return FutureBuilder<bool>(
            future: _isAdmin(),
            builder: (context, adminSnapshot) {
              if (!adminSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (!adminSnapshot.data!) {
                return Center(
                  child: Text('คุณไม่มีสิทธิ์เข้าถึงหน้านี้'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final userData = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(userData['username'] ?? 'ไม่ระบุชื่อผู้ใช้'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData['email'] ?? 'ไม่ระบุอีเมล'),
                          Text('บทบาท: ${userData['role'] ?? 'ไม่ระบุ'}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: const Color.fromARGB(255, 66, 66, 66)),
                            onPressed: () => _editUser(doc.id, userData),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: const Color.fromARGB(255, 66, 66, 66)),
                            onPressed: () => _deleteUser(doc.id,
                                userData['username'] ?? 'ไม่ระบุชื่อผู้ใช้'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
