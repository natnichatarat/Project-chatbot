import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/ProfileEdit.dart';
import 'package:project/components/drop_down_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project/components/input_field_num.dart';
import 'package:project/components/input_field_phone.dart';
import 'dart:io';
import 'package:project/components/input_field_text.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: AddDormScreen(),
    );
  }
}

class AddDormScreen extends StatefulWidget {
  @override
  _AddDormScreenState createState() => _AddDormScreenState();
}

class _AddDormScreenState extends State<AddDormScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  BuildContext? _contextRef;
  File? _imageFile;
  bool _isUploading = false;
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedDaysStart;
  String? selectedDaysLatest;
  String? selectedDaysBussiness;
  String? selectedDaysBuilding;
  String? selectedTpye1Room;
  String? selectedTpye2Room;
  String? selected1,
      selected2,
      selected3,
      selected4,
      selected5,
      selected6,
      selected7,
      selected8,
      selected9,
      selected10,
      selected11,
      selected12,
      selected13,
      selected14,
      selected15,
      selected16,
      selected17,
      selected18,
      selected19,
      selected20,
      selected21,
      selected22,
      selected23,
      selected24,
      selected25;

  final TextEditingController dormNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController subdistrictController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController buildingTypeController = TextEditingController();
  final TextEditingController businessTypeController = TextEditingController();
  final TextEditingController billingDateController = TextEditingController();
  final TextEditingController paymentDueController = TextEditingController();
  final TextEditingController floorCountController = TextEditingController();
  final TextEditingController priceRoomController = TextEditingController();
  final TextEditingController recognizanceController = TextEditingController();
  final TextEditingController advancepaymentController =
      TextEditingController();
  final TextEditingController electricityController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController lineController = TextEditingController();
  final TextEditingController internetController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final TextEditingController roomPriceFanController = TextEditingController();
  final TextEditingController roomPriceAriController = TextEditingController();
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      return 'กรุณากรอกอีเมลให้ถูกต้อง';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง (10 หลัก)';
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเลือกรูปภาพ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Image upload function
  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      setState(() {
        _isUploading = true;
      });

      String fileName =
          'dorm_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child(fileName);

      await storageRef.putFile(_imageFile!);
      final imageUrl = await storageRef.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      return imageUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      throw Exception('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ: ${e.toString()}');
    }
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) {
      return 'กรุณากรอกตัวเลขให้ถูกต้อง';
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contextRef = context;
    // บันทึก reference ของ Firestore ที่นี่
  }

  @override
  void deactivate() {
    // จัดการ cleanup ที่เกี่ยวข้องกับ context ที่นี่
    _contextRef = null;
    super.deactivate();
  }

  @override
  @override
  void dispose() {
    if (scaffoldMessengerKey.currentState != null && mounted) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Widget ถูกลบแล้ว"),
        ),
      );
    }

    _contextRef = null;
    // dispose controllers
    dormNameController.dispose();
    addressController.dispose();
    subdistrictController.dispose();
    districtController.dispose();
    provinceController.dispose();
    phoneController.dispose();
    emailController.dispose();
    codeController.dispose();
    buildingTypeController.dispose();
    businessTypeController.dispose();
    billingDateController.dispose();
    paymentDueController.dispose();
    floorCountController.dispose();
    priceRoomController.dispose();
    recognizanceController.dispose();
    advancepaymentController.dispose();
    electricityController.dispose();
    waterController.dispose();
    lineController.dispose();
    internetController.dispose();
    otherController.dispose();
    roomPriceFanController.dispose();
    roomPriceAriController.dispose();
    _imageFile = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ข้อมูลหอพักของฉัน",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // หัวข้อ "ชื่อหอพัก"
              sectionTitle("ชื่อหอพัก *"),
              InputField(
                controller: dormNameController,
                hint: "กรอกข้อมูล",
              ),
              Divider(),
              // หัวข้อ "ที่อยู่"
              sectionTitle("ที่อยู่ *"),
              InputField(
                  controller: addressController, hint: "เลขที่/ถนน/ซอย/อาคาร"),
              InputField(controller: subdistrictController, hint: "ตำบล"),
              InputField(controller: districtController, hint: "อำเภอ"),
              InputField(controller: provinceController, hint: "จังหวัด"),
              InputField(controller: codeController, hint: "รหัสไปรษณีย์"),
              Divider(),
              sectionTitle("อัพโหลดรูปภาพ *"),
              _buildImagePickerSection(),
              Divider(),
              sectionTitle("ประเภทห้องพัก *"),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // ✅ จัดให้ข้อความชิดซ้าย
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2), // ✅ เพิ่มระยะห่างเล็กน้อย
                    child: Text(
                      "ห้องพัดลม",
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                        child: dropdownField(
                            title: "โปรดเลือก",
                            selectedValue: selectedTpye1Room,
                            items: ["มี", "ไม่มี"],
                            onChanged: (value) {
                              setState(() => selectedTpye1Room = value);
                            }),
                      ),
                      SizedBox(width: 10), // ✅ เพิ่มระยะห่างระหว่างช่อง
                      Expanded(
                        flex: 2, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                        child: InputFieldNum(
                            controller: roomPriceFanController,
                            //keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            hint: "ราคา/เดือน"),
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text("ห้องแอร์"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                        child: dropdownField(
                            title: "โปรดเลือก",
                            selectedValue: selectedTpye2Room,
                            items: ["มี", "ไม่มี"],
                            onChanged: (value) {
                              setState(() => selectedTpye2Room = value);
                            }),
                      ),
                      SizedBox(width: 10), // ✅ เพิ่มระยะห่างระหว่างช่อง
                      Expanded(
                        flex: 2, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                        child: InputFieldNum(
                            controller: roomPriceAriController,
                            //keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            hint: "ราคา/เดือน"),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              sectionTitle("ค่าสาธารณูปโภค *"),
              InputFieldNum(
                controller: electricityController,
                hint: "ค่าไฟ/ยูนิต",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  LengthLimitingTextInputFormatter(3)
                ],
              ),
              InputField(
                  controller: waterController, hint: "ค่าน้ํา/หน่วยหรือ/คน"),
              InputFieldNum(
                  controller: internetController, hint: "ค่าอินเตอร์เน็ต/คน"),
              InputField(
                  controller: otherController,
                  hint: "ค่าอื่น ๆ เช่น 'ค่าส่วนกลาง 200 บาท'"),

              sectionTitle("ค่าใช้จ่าย *"),
              InputFieldNum(
                  controller: advancepaymentController,
                  //keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                    LengthLimitingTextInputFormatter(5)
                  ],
                  hint: "ค่าจ่ายล่วงหน้า"),
              InputFieldNum(
                  controller: recognizanceController,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                    LengthLimitingTextInputFormatter(5)
                  ],
                  hint: "ค่าเงินประกัน"),

              Divider(),
              // หัวข้อ "การติดต่อ *"
              sectionTitle("การติดต่อ *"),
              InputFieldPhone(
                controller: phoneController,
                hint: "เบอร์โทรศัพท์",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  LengthLimitingTextInputFormatter(10)
                ],
              ),
              InputField(controller: emailController, hint: "E-mail"),
              InputField(controller: lineController, hint: "Line(ถ้ามี)"),

              Divider(),

              sectionTitle("สิ่งอำนวยความสะดวก "),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("อินเตอร์เน็ต")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected1,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected1 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("เครื่องทำน้ำอุ่น	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected2,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected2 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("อนุญาตให้เลี้ยงสัตว์	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected3,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected3 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("บริการเครื่องซักผ้า")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected4,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected4 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              // ------------   ------------
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ตู้เย็น")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected5,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected5 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ระเบียง	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected6,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected6 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("เฟอร์นิเจอร์-ตู้,เตียง,โต๊ะ-เกาอี้	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected7,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected7 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("Keycard")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected8,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected8 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              //----------------------------------
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("CCTV")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected9,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected9 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("สแกนลายนิ้วมือ	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected10,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected10 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ที่จอดรถยนต์		")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected11,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected11 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ที่จอดรถจักรยาน/จักรยานยนต์")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected12,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected12 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("เคเบิลทีวี/ดาวเทียม")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected13,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected13 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("อนุญาตให้สูบบุหรี่ในห้องพัก	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected14,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected14 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("รปภ.")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected15,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected15 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("สระว่ายน้ำ	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected16,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected16 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              //----------------------------------
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("โรงยิม/ฟิตเนส	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected17,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected17 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ร้านทำผม-เสริมสวย	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected18,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected18 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ลิฟต์	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected19,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected19 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ร้านค้า")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected20,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected20 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),

              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("ร้านอาหาร")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected21,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected21 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("เตาปรุงอาหาร	")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected23,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected23 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1, // ✅ กำหนดให้ช่องกรอกราคาแคบลง
                      child: Text("อนุญาตให้ทำอาหาร")),
                  Expanded(
                    flex: 2, // ✅ กำหนดให้ Dropdown กว้างขึ้นเล็กน้อย
                    child: dropdownField(
                        title: "โปรดเลือก",
                        selectedValue: selected24,
                        items: ["มี", "ไม่มี"],
                        onChanged: (value) {
                          setState(() => selected24 = value);
                        }),
                  ),
                  // ✅ เพิ่มระยะห่างระหว่างช่อง
                ],
              ),

              SizedBox(height: 20),

              SizedBox(height: 20),

              // ปุ่ม "บันทึก" และ "แก้ไข"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButton("บันทึก", Colors.deepPurple, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สำหรับแสดงหัวข้อแต่ละส่วน
  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'poppins'),
        ),
      ),
    );
  }

  // Widget สำหรับสร้างปุ่ม
  Widget buildButton(String text, Color color, BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80),
        child: ElevatedButton(
          onPressed: () {
            showConfirmationDialog(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            backgroundColor: color,
            /*side: const BorderSide(
              color: Color.fromARGB(100, 140, 28, 218), // สีของขอบ
              width: 2.5, // ความหนาของขอบ
            ),*/
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'poppins', // ใช้ฟอนต์ที่กำหนด
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการบันทึก"),
          content: Text("คุณแน่ใจหรือไม่ว่าข้อมูลถูกต้อง?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveData(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveData(BuildContext context) async {
    if (!mounted) return;

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อน');
      }

      if (dormNameController.text.isEmpty ||
          addressController.text.isEmpty ||
          phoneController.text.isEmpty) {
        throw Exception('กรุณากรอกข้อมูลที่จำเป็นให้ครบถ้วน');
      }
      // ✅ อัปโหลดรูปภาพก่อน (ถ้ามี)
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage();
      } //แชทแนะนํามางับ

      // final BuildContext localContext = context;
      //if (!mounted) return;

      final Map<String, dynamic> dormData = {
        'ownerId': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'dormName': dormNameController.text.trim(),
        'address': {
          'fullAddress': addressController.text.trim(),
          'subdistrict': subdistrictController.text.trim(),
          'district': districtController.text.trim(),
          'province': provinceController.text.trim(),
          'code': codeController.text.trim(),
        },
        'rooms': {
          'types': {
            'fan': {
              'available': selectedTpye1Room == 'มี',
              'price': double.tryParse(roomPriceFanController.text) ?? 0,
            },
            'airConditioned': {
              'available': selectedTpye2Room == 'มี',
              'price': double.tryParse(roomPriceAriController.text) ?? 0,
            },
          },
        },
        'utilities': {
          'electricity': double.tryParse(electricityController.text) ?? 0,
          'water': waterController.text.trim(),
          'internet': double.tryParse(internetController.text) ?? 0,
          'other': otherController.text.trim(),
        },
        'fees': {
          'deposit': double.tryParse(recognizanceController.text) ?? 0,
          'advance': double.tryParse(advancepaymentController.text) ?? 0,
        },
        'contact': {
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'line': lineController.text.trim(),
        },
        'facilities': {
          'internet': selected1 == 'มี',
          'waterHeater': selected2 == 'มี',
          'petsAllowed': selected3 == 'มี',
          'laundry': selected4 == 'มี',
          'refrigerator': selected5 == 'มี',
          'balcony': selected6 == 'มี',
          'furniture': selected7 == 'มี',
          'keycard': selected8 == 'มี',
          'cctv': selected9 == 'มี',
          'fingerprint': selected10 == 'มี',
          'carPark': selected11 == 'มี',
          'motorcyclePark': selected12 == 'มี',
          'cableTV': selected13 == 'มี',
          'smokingAllowed': selected14 == 'มี',
          'security': selected15 == 'มี',
          'pool': selected16 == 'มี',
          'gym': selected17 == 'มี',
          'salon': selected18 == 'มี',
          'elevator': selected19 == 'มี',
          'shop': selected20 == 'มี',
          'restaurant': selected21 == 'มี',
          'stove': selected23 == 'มี',
          'cookingAllowed': selected24 == 'มี',
        }
      };

      await FirebaseFirestore.instance.collection('dormitories').add(dormData);
      if (!mounted) return;

      clearFields(); // ✅ ล้างค่าหลังบันทึกสำเร็จ

      // ✅ ใช้ setState() เพื่ออัปเดต UI และแสดง SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึกข้อมูลหอพักสำเร็จ!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      ); //ไม่แสดงทำไมควยไร

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void clearFields() {
    dormNameController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    buildingTypeController.clear();
    businessTypeController.clear();
    billingDateController.clear();
    paymentDueController.clear();
    floorCountController.clear();
    subdistrictController.clear();
    districtController.clear();
    provinceController.clear();
    priceRoomController.clear();
    recognizanceController.clear();
    advancepaymentController.clear();
    electricityController.clear();
    waterController.clear();
    lineController.clear();
    internetController.clear();
    otherController.clear();
    roomPriceFanController.clear();
    roomPriceAriController.clear();
    codeController.clear();

    // เคลียร์ค่า dropdown และค่าที่เลือก
    setState(() {
      selectedProvince = null;
      selectedDistrict = null;
      selectedSubDistrict = null;
      selectedDaysStart = null;
      selectedDaysLatest = null;
      selectedDaysBussiness = null;
      selectedDaysBuilding = null;
      selectedTpye1Room = null;
      selectedTpye2Room = null;
      selected1 = null;
      selected2 = null;
      selected3 = null;
      selected4 = null;
      selected5 = null;
      selected6 = null;
      selected7 = null;
      selected8 = null;
      selected9 = null;
      selected10 = null;
      selected11 = null;
      selected12 = null;
      selected13 = null;
      selected14 = null;
      selected15 = null;
      selected16 = null;
      selected17 = null;
      selected18 = null;
      selected19 = null;
      selected20 = null;
      selected21 = null;
      selected22 = null;
      selected23 = null;
      selected24 = null;
      selected25 = null;
      _imageFile = null;
    });
  }

// ฟังก์ชันสำหรับล้างค่าทั้งหมด

  Widget _buildImagePickerSection() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: _imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.add_photo_alternate,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
        ),
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickImage,
          icon: Icon(Icons.photo_library, color: Colors.white),
          label: Text(_imageFile == null ? 'เลือกรูปภาพ' : 'เปลี่ยนรูปภาพ'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        if (_isUploading)
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
