import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView( //  ป้องกัน Overflow เมื่อพื้นที่ไม่พอ
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'สมาชิกในทีม',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade800),
              ),
              SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true, //  ให้ GridView ปรับขนาดอัตโนมัติ
                physics: NeverScrollableScrollPhysics(), // ป้องกันการเลื่อนซ้อน
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, //  ปรับขนาดการ์ดให้ใหญ่ขึ้น
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65, // ลดค่าเพื่อให้การ์ดสูงขึ้น
                ),
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  return _buildMemberCard(context, teamMembers[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, TeamMember member) {
    return GestureDetector(
      onTap: () => _showFullImage(context, member.imagePath),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.black26,
        child: Column(
          children: [
            Hero(
              tag: member.imagePath,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    member.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded( // ✅ ทำให้ส่วนข้อความขยายตัวตามพื้นที่ที่เหลือ
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6), // ✅ เพิ่ม padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // ✅ ทำให้ข้อความอยู่ตรงกลาง
                  children: [
                    Flexible( // ✅ ป้องกันข้อความล้น
                      child: Text(
                        member.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 4), // ✅ เพิ่มระยะห่าง
                    Flexible( // ✅ ป้องกัน overflow
                      child: Text(
                        member.id,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Hero(
            tag: imagePath,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 300, // ✅ กำหนดขนาดให้รูปขยาย
                height: 300, // ✅ กำหนดขนาดให้รูปขยาย
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TeamMember {
  final String name;
  final String id;
  final String imagePath;
  TeamMember({required this.name, required this.id, required this.imagePath});
}

final List<TeamMember> teamMembers = [
  TeamMember(name: 'Nattawut Klubthong', id: '66102010138', imagePath: 'assets/nattawut.jpg'),
  TeamMember(name: 'Purinut Satronkit', id: '66102010150', imagePath: 'assets/purinut.jpg'),
  TeamMember(name: 'Sirayuth Chotithammaporn', id: '66102010153', imagePath: 'assets/sirayuth.jpg'),
];