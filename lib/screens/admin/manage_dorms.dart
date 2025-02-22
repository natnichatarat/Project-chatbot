import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageDormsScreen extends StatefulWidget {
  @override
  _ManageDormsScreenState createState() => _ManageDormsScreenState();
}

class _ManageDormsScreenState extends State<ManageDormsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ตรวจสอบสถานะ admin
  Future<bool> _isAdmin() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      return userDoc.data()?['role'] == 'admin' ||
          userDoc.data()?['email'] == 'opalnatni@gmail.com';
    } catch (e) {
      print('เกิดข้อผิดพลาดในการตรวจสอบ admin: $e');
      return false;
    }
  }

  // ลบหอพัก
  Future<void> _deleteDorm(String dormId) async {
    try {
      await _firestore.collection('dormitories').doc(dormId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบหอพักสำเร็จ')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการลบหอพัก: $e')),
      );
    }
  }

  // Dialog ยืนยันการลบ
  void _showDeleteConfirmation(String dormId, String dormName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณแน่ใจหรือไม่ว่าต้องการลบ $dormName ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ยกเลิก"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteDorm(dormId);
              },
              child: Text("ลบ", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  // Dialog แก้ไขข้อมูลหอพัก
  void _showEditDialog(String dormId, Map<String, dynamic> dormData) {
    final TextEditingController nameController =
        TextEditingController(text: dormData['dormName']);
    final TextEditingController addressController =
        TextEditingController(text: dormData['address']['fullAddress']);
    final TextEditingController roomsController =
        TextEditingController(text: dormData['rooms']['totalRooms'].toString());
    final TextEditingController floorsController = TextEditingController(
        text: dormData['rooms']['totalFloors'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลหอพัก'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อหอพัก'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'ที่อยู่'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: roomsController,
                  decoration: InputDecoration(labelText: 'จำนวนห้อง'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: floorsController,
                  decoration: InputDecoration(labelText: 'จำนวนชั้น'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _firestore
                      .collection('dormitories')
                      .doc(dormId)
                      .update({
                    'dormName': nameController.text,
                    'address.fullAddress': addressController.text,
                    'rooms.totalRooms': int.tryParse(roomsController.text) ?? 0,
                    'rooms.totalFloors':
                        int.tryParse(floorsController.text) ?? 0,
                    'lastUpdated': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('อัพเดทข้อมูลสำเร็จ')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('เกิดข้อผิดพลาดในการอัพเดทข้อมูล: $e')),
                  );
                }
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการหอพัก',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<bool>(
        stream: Stream.fromFuture(_isAdmin()),
        builder: (context, adminSnapshot) {
          if (adminSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // กำหนด query ตามสิทธิ์
          Query dormQuery = _firestore.collection('dormitories');
          if (!adminSnapshot.data!) {
            // ถ้าไม่ใช่ admin ให้ดูได้เฉพาะหอของตัวเอง
            dormQuery =
                dormQuery.where('ownerId', isEqualTo: _auth.currentUser?.uid);
          }

          return StreamBuilder<QuerySnapshot>(
            stream: dormQuery.snapshots(),
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
                    "ไม่มีข้อมูลหอพัก",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final dorm = snapshot.data!.docs[index];
                  final dormData = dorm.data() as Map<String, dynamic>;

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.apartment, color: Colors.purple, size: 30),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dormData['dormName'] ?? 'ไม่มีชื่อ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "ที่ตั้ง: ${dormData['address']['fullAddress'] ?? 'ไม่ระบุ'}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                Text(
                                  "จำนวนห้อง: ${dormData['rooms']['totalRooms'] ?? '0'} ห้อง",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                // แสดงข้อมูลเจ้าของหอพักเฉพาะ admin
                                if (adminSnapshot.data!)
                                  FutureBuilder<DocumentSnapshot>(
                                    future: _firestore
                                        .collection('users')
                                        .doc(dormData['ownerId'])
                                        .get(),
                                    builder: (context, ownerSnapshot) {
                                      if (ownerSnapshot.hasData) {
                                        final ownerData = ownerSnapshot.data!
                                            .data() as Map<String, dynamic>?;
                                        return Text(
                                          "เจ้าของ: ${ownerData?['username'] ?? 'ไม่ระบุ'}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        );
                                      }
                                      return SizedBox();
                                    },
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _showEditDialog(dorm.id, dormData),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteConfirmation(
                                    dorm.id,
                                    dormData['dormName'] ?? 'ไม่มีชื่อ'),
                              ),
                            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addDorm');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
