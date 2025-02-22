import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DormDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final details = args?['details'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(args?['title'] ?? 'รายละเอียดหอพัก'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปภาพหลัก
            if (args?['image'] != null)
              Container(
                height: 250,
                width: double.infinity,
                child: Image.network(
                  args!['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Icon(Icons.error, size: 50, color: Colors.white),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ชื่อหอพัก
                  Text(
                    args?['title'] ?? 'ไม่พบชื่อหอพัก',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  // คำอธิบายย่อ
                  Text(
                    args?['subtitle'] ?? 'ไม่พบรายละเอียด',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 65, 65, 65),
                    ),
                  ),

                  Divider(height: 24),

                  // ราคา
                  _buildInfoItem(
                    icon: Icons.attach_money,
                    title: 'ราคา',
                    content: details?['price'] ?? 'ไม่ระบุ',
                  ),
                  SizedBox(height: 14),

                  // ประเภทห้อง
                  _buildInfoItem(
                    icon: Icons.hotel,
                    title: 'ประเภทห้อง',
                    content: (details?['roomTypes'] as List?)?.join(' ') ??
                        'ไม่ระบุ',
                  ),
                  SizedBox(height: 14),

                  // ค่าสาธารณูปโภค
                  _buildInfoItem(
                    icon: Icons.payments,
                    title: 'ค่าสาธารณูปโภค',
                    content: (details?['consume'] as List?)?.join(' \n ') ??
                        'ไม่ระบุ',
                  ),
                  SizedBox(height: 8),

                  // สิ่งอำนวยความสะดวก
                  _buildFacilitiesItem(
                    icon: Icons.room_service,
                    title: 'สิ่งอำนวยความสะดวก',
                    facilities: details?['facilities'] as List<dynamic>?,
                  ),
                  SizedBox(height: 16),

                  // ที่อยู่
                  _buildInfoItem(
                    icon: Icons.location_on,
                    title: 'ที่อยู่',
                    content: details?['address'] ?? 'ไม่ระบุ',
                    onTap: () async {
                      final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(details?['address'] ?? '')}',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  SizedBox(height: 14),

                  // เบอร์ติดต่อ
                  _buildInfoItem(
                    icon: Icons.phone,
                    title: 'ติดต่อ',
                    content: details?['contact'] ?? 'ไม่ระบุ',
                    onTap: () async {
                      final url = Uri.parse('tel:${details?['contact']}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    String? content,
    List<String>? chips,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                if (content != null)
                  Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  )
                else if (chips != null)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: chips
                        .map((chip) => Chip(
                              label: Text(chip),
                              backgroundColor: Colors.deepPurple,
                              labelStyle: TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
          if (onTap != null) Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildFacilitiesItem({
    required IconData icon,
    required String title,
    required List<dynamic>? facilities,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              if (facilities != null)
                ...facilities.map((facility) {
                  if (facility is Map<String, dynamic>) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          if (facility['icon'] != null)
                            Image.network(
                              facility['icon'],
                              width: 20,
                              height: 20,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error_outline, size: 20);
                              },
                            ),
                          SizedBox(width: 8),
                          Text(facility['text'] ?? ''),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(facility.toString()),
                  );
                }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
